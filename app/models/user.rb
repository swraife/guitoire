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
#

class User < ApplicationRecord
  include SongRoleable
  include TrackableAssociations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :group_roles
  has_many :groups, through: :group_roles

  has_many :messages
  has_many :message_copies
  has_many :user_message_threads
  has_many :message_threads, through: :user_message_threads

  has_many :plays
  has_many :played_songs, -> { uniq }, through: :plays, source: :song

  has_many :resources, as: :creator

  has_many :created_songs, class_name: 'Song', foreign_key: :creator_id

  has_many :songs, through: :song_roles
  has_many :admin_songs, through: :admin_song_roles, source: :song
  has_many :viewer_songs, through: :viewer_song_roles, source: :song
  has_many :follower_songs, through: :follower_song_roles, source: :song
  has_many :subscriber_songs, through: :subscriber_song_roles, source: :song

  has_many :routine_roles, as: :owner
  has_many :routines, through: :routine_roles
  has_many :routines_as_owner, class_name: 'Routine', as: :owner

  has_many :set_list_songs, through: :routines

  before_create { |user| user.first_name.capitalize! && user.last_name.capitalize! }

  acts_as_tagger

  has_attached_file :avatar, styles: { medium: '300x300#', thumb: '100x100#' }, default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/png']

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
end
