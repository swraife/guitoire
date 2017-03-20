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
#

class User < ApplicationRecord
  include Actor
  include GroupRoleable
  include RoutineRoleOwner
  include SongRoleOwner
  include TrackableAssociations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups, through: :group_roles
  has_many :admin_groups, through: :admin_group_roles, source: :group
  has_many :member_groups, through: :member_group_roles, source: :group

  has_many :messages
  has_many :message_copies
  has_many :user_message_threads
  has_many :message_threads, through: :user_message_threads

  has_many :plays
  has_many :played_songs, -> { distinct }, through: :plays, source: :song

  has_many :resources, as: :creator

  has_many :created_songs, class_name: 'Song', foreign_key: :creator_id

  has_many :set_list_songs, through: :routines

  enum role: [:subscriber, :admin]
  enum visibility: [:everyone, :friends]

  before_create { |user| user.first_name.capitalize! && user.last_name.capitalize! }

  acts_as_tagger

  has_attached_file :avatar, styles: { medium: '300x300#', thumb: '100x100#' }, default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  # TODO: Add friends to query
  def self.visible_to(user)
    # Can't currently do in one OR query w/ AR, because of bug w/ joining.
    friend_ids = [user.id]
    where(visibility: 0).or(where(id: friend_ids))
  end

  def song_tags(context = nil)
    context_query = context.nil? ? '' : { taggings: { context: context } }
    ActsAsTaggableOn::Tag.includes(:taggings)
                         .where(taggings: { taggable: songs })
                         .where(context_query)
  end

  def name
    name = "#{first_name} #{last_name}"
    name.present? ? name : "User#{id}"
  end

  def actors
    [self, groups].flatten
  end

  def may_edit?(target)
    target.editor_roles_for(actors).present?
  end

  # TODO: Delete this when actually implementing friendships
  def friends
    []
  end

  def visible_to?(user)
    user == self || everyone? || friends.include?(user)
  end

  # makes owners(group || user) both respond to #users for authorization.
  def users
    [self]
  end
end
