# == Schema Information
#
# Table name: songs
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  music_key      :string
#  tempo          :integer
#  composer_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :integer
#  scale          :string
#  time_signature :string
#  permission     :integer          default("copiable")
#

class Song < ApplicationRecord
  include PublicActivity::Model
  include TrackableAssociations
  include SongRoleable

  tracked only: [:create], owner: :creator

  has_many :users, through: :song_roles
  has_many :admin_users, through: :admin_song_roles, source: :user
  has_many :viewer_users, through: :viewer_song_roles, source: :user
  has_many :follower_users, through: :follower_song_roles, source: :user

  belongs_to :composer
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id

  has_many :resources, as: :target, dependent: :destroy
  has_many :file_resources, through: :resources, source: :resourceable, source_type: 'FileResource'
  has_many :url_resources, through: :resources, source: :resourceable, source_type: 'UrlResource'

  has_many :tags, through: :taggings
  has_many :plays, through: :song_roles
  has_many :players, -> { uniq }, through: :plays, source: :user

  acts_as_taggable_on :composers, :versions, :genres, :generics

  after_create :create_song_role

  enum permission: [:copiable, :followable, :hidden]

  MUSICKEYS = %w(A A# B B# C D D# E F F# G G#)
  SCALES = %w(Major Minor Blues)
  TIME_SIGNATURES = ['4/4', '3/4', '2/4', '3/8']

  def permissible_roles
    return [0, 2] unless hidden?
    []
  end

  private

  def create_song_role
    SongRole.create(user_id: creator_id, song_id: id, role: 1)
  end
end
