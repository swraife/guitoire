# == Schema Information
#
# Table name: performers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  name                :string
#  public_name         :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  description         :text
#  email               :string
#  visibility          :integer          default("everyone")
#  settings            :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  area_id             :integer
#

class Performer < ApplicationRecord
  include Actor
  include GroupRoleable
  include PgSearch
  include RoutineRoleOwner
  include FeatRoleOwner

  belongs_to :area
  belongs_to :user
  # This only exists to allow eager loading of activities.recipient.creator
  belongs_to :creator, foreign_key: :id, class_name: 'Performer'

  has_many :follows, dependent: :destroy
  has_many :followers, through: :follows

  has_many :follows_as_follower, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
  has_many :followed, source: :performer, through: :follows_as_follower

  has_many :groups, through: :group_roles
  has_many :admin_groups, through: :admin_group_roles, source: :group
  has_many :member_groups, through: :member_group_roles, source: :group

  has_many :messages
  has_many :message_copies
  has_many :performer_message_threads
  has_many :message_threads, through: :performer_message_threads

  has_many :plays
  has_many :played_feats, -> { distinct }, through: :plays, source: :feat

  has_many :resources, as: :creator
  has_many :created_feats, class_name: 'Feat', foreign_key: :creator_id
  has_many :routine_feats, through: :routines

  # default_scope { includes(:user) }

  acts_as_taggable_on :standard_skills, :user_input_skills, :followed_skills
  store_accessor :settings, :feat_contexts, :feat_role_contexts, :feat_name, :routine_name

  before_save :format_custom_contexts, :downcase_username
  after_create :user_default_performer, :create_followed_skills

  enum visibility: [:everyone, :hidden]

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/:style/default_avatar.png'
  validates_attachment_content_type :avatar,
                                    content_type: ['image/jpg', 'image/jpeg', 'image/png']
  validates_uniqueness_of :username

  multisearchable against: :public_name

  def self.visible_to(performer)
    where(visibility: 0).or(where(id: performer.id))
  end

  def visible_to?(performer)
    performer == self || everyone?
  end

  def public_name
    self[:public_name] || user.public_name
  end

  def skills
    base_tags.where(id: standard_skill_ids + user_input_skill_ids).distinct
  end

  def actors
    [self, groups].flatten
  end

  # makes owners(group || performer) both respond to #performers for authorization.
  def performers
    [self]
  end

  private

  def user_default_performer
    user.update(default_performer: self) unless user.default_performer
  end

  def create_followed_skills
    base_tags.each do |tag|
      ActsAsTaggableOn::Tagging.create(tag: tag,
                                        taggable: self,
                                        context: 'followed_skills') 
    end
  end

  def format_custom_contexts
    if feat_contexts.is_a? Array
      self.feat_contexts = feat_contexts.each_with_object({}) do |context, hsh|
        hsh[Contexts.name_for(context)] = context if context.present?
      end
    end
  end

  def downcase_username
    username.downcase!
  end
end
