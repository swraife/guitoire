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
  include Friendships
  include GroupRoleable
  include RoutineRoleOwner
  include SongRoleOwner

  belongs_to :area
  belongs_to :user
  # This only exists to allow eager loading of activities.recipient.creator
  belongs_to :creator, foreign_key: :id, class_name: 'Performer'

  has_many :groups, through: :group_roles
  has_many :admin_groups, through: :admin_group_roles, source: :group
  has_many :member_groups, through: :member_group_roles, source: :group

  has_many :plays
  has_many :played_songs, -> { distinct }, through: :plays, source: :song

  has_many :resources, as: :creator
  has_many :created_songs, class_name: 'Song', foreign_key: :creator_id
  has_many :set_list_songs, through: :routines

  has_many :tags, through: :taggings

  # default_scope { includes(:user) }

  acts_as_taggable_on :skills, :user_input_skills, :followed_skills

  after_create :user_default_performer

  enum visibility: [:everyone, :friends]

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar,
                                    :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  # TODO: Add friends to query
  def self.visible_to(performer)
    # Can't currently do in one OR query w/ AR, because of bug w/ joining.
    friend_ids = [performer.id]
    where(visibility: 0).or(where(id: friend_ids))
  end

  def public_name
    self[:public_name] || user.public_name
  end

  def song_tags(context = nil)
    context_query = context.nil? ? '' : { taggings: { context: context } }
    ActsAsTaggableOn::Tag.includes(:taggings)
                         .where(taggings: { taggable: songs })
                         .where(context_query)
  end

  def actors
    [self, groups].flatten
  end

  def visible_to?(performer)
    performer == self || everyone? || friends.include?(performer)
  end

  # makes owners(group || performer) both respond to #performers for authorization.
  def performers
    [self]
  end

  private

  def user_default_performer
    user.update(default_performer: self) unless user.default_performer
  end
end
