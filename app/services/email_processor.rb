class EmailProcessor
  attr_reader :email
  attr_accessor :feat, :resource_status, :feat_status

  def initialize(email)
    @email = email
  end

  def process
    create_received_email
    return unless sender
    create_or_set_feat
    create_file_resources
  end

  private

  def create_received_email
    ReceivedEmail.create(to: email.to,
                         from: email.from,
                         body: email.body,
                         subject: email.subject,
                         headers: email.headers,
                         sender: sender)
  end

  # If there is only one match and there are email attachments, it can be
  # assumed they want to add those attachemnts to that feat. If there are
  # multiple matches, we don't know which to add the attachments to. If
  # there are no attachments, and one or more matches, it might be a new
  # feat or an accidental duplicate, so we'll create it as pending
  def create_or_set_feat
    if feat_matches.length == 1 && email.attachments.present?
      self.resource_status = 'published'
      self.feat = feat_matches.first[:match]
    elsif feat_matches.length > 1 && email.attachments.present?
      self.resource_status = 'pending'
      self.feat = Feat.new
    elsif feat_matches.length > 0 && email.attachments.empty?
      self.feat_status = 'pending'
      self.feat = create_feat
    elsif feat_matches.length.zero?
      self.feat_status = 'published'
      self.resource_status = 'published'
      self.feat = create_feat
    end
  end

  def create_feat
    Feat.create!(owner: owner,
                 name: email.subject,
                 status: feat_status,
                 visibility: owner&.default_feat_visibility)
  end

  def create_file_resources
    email.attachments.each do |attachment|
      file_resource = create_file_resource(attachment)
      file_resource.resources.create!(target: resource_target,
                                      name: file_resource.main_file_name,
                                      status: resource_status,
                                      creator: owner)
    end
  end

  def resource_target
    feat.feat_roles.subscriber.where(owner: sender.actors).first
  end

  def create_file_resource(attachment)
    FileResource.create!(main: attachment)
  end

  def performr_recipients
    @performr_recipients ||=
      email.to.each_with_object([]) do |(k,v), obj|
        obj.push(k[:token].downcase) if k[:host] == 'performr.world'
      end
  end

  def sender
    @sender ||= User.find_by_email(email.from[:email])
  end

  # Returns the sender's performer if there is only one.
  # If there are multiple performers, returns the ONE that matches
  # the sender\'s email. If there are multiple matches, returns nil.
  # Obviously not an ideal solution for user experience.
  def owner
    @owner ||=
      if sender
        if sender_performers.count > 1
          matches = sender_performers.where(email: email.from[:email])
          matches.count > 1 ? sender : matches.first
        else
          sender_performers.first
        end
      end
  end

  def sender_performers
    @sender_performers ||= sender.performers
  end

  def feat_matches
    @feat_matches ||=
      NameMatcher.new(email.subject,
                      sender.actors_subscriber_feats).find_matches
  end
end
