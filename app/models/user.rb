# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string           default("")
#  last_name              :string           default("")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  role                   :integer          default("subscriber")
#  visibility             :integer          default("everyone")
#  default_performer_id   :integer
#  email_settings         :jsonb
#

class User < ApplicationRecord
  include TrackableAssociations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :default_performer, class_name: 'Performer'

  has_many :performers

  enum role: [:subscriber, :admin]
  enum visibility: [:everyone, :friends]

  before_create { |user| user.first_name.capitalize! && user.last_name.capitalize! }
  before_save :add_email_settings

  acts_as_tagger

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar,
                                    :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  store_accessor :email_settings, :subscribed

  def performer_tags(context = nil)
    context_query = context.nil? ? '' : { taggings: { context: context } }
    ActsAsTaggableOn::Tag.includes(:taggings)
                         .where(taggings: { taggable: performers })
                         .where(context_query)    
  end

  def actors
    performers.map { |performer| [performer, performer.groups] }.flatten
  end

  def actors_subscriber_feats
    Feat.joins(:feat_roles).where(feat_roles: { owner: actors, role: [1,2] })
  end

  def admin_group_ids
    @admin_group_ids ||=
      GroupRole.where(performer_id: performer_ids, role: [1,2])
      .pluck('distinct group_id')
  end

  def admin_feat_ids
    @admin_feat_ids ||=
      FeatRole.where(owner: actors, role: 'admin').pluck('distinct feat_id')
  end

  def public_name
    name = "#{first_name} #{last_name}"
    name.present? ? name : "User#{id}"
  end

  def subscribed?
    subscribed == true
  end

  def default_feat_visibility
    @default_feat_visibility ||=
      if Feat.where(owner: performers)
             .pluck(:visibility)
             .include? 'only_admins'
        'only_admins'
      else
        'everyone'
      end
  end

  private

  def add_email_settings
    if subscribed.nil?
      self.subscribed = 'true'
    end
  end
end
