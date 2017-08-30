class EmailProcessor
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def process
    create_received_email
    create_feat if sender && performr_recipients.include?('new')
  end

  private

  def create_received_email
    ReceivedEmail.create(to: email.to,
                         from: email.from,
                         body: email.body,
                         subject: email.subject,
                         sender: sender)
  end

  def create_feat
    feat = Feat.create(owner: owner,
                       name: email.subject,
                       visibility: owner&.default_feat_visibility)
    email.attachments.each do |attachment|
      file_resource = create_file_resource(attachment)
      file_resource.resources.create(target: feat,
                                     name: file_resource.main_file_name,
                                     creator: owner)
    end
  end

  def create_file_resource(attachment)
    FileResource.create(main: attachment)
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
end
