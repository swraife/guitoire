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
  has_many :users, through: :song_roles
  has_many :song_roles

  belongs_to :composer

  has_many :song_resources
  has_many :resources, through: :song_resources

  has_many :tags, through: :taggings

  belongs_to :creator, class_name: 'User', foreign_key: :creator_id

  acts_as_taggable_on :composers, :versions, :genres, :generics

  after_create :create_song_role

  enum permission: [:copiable, :followable, :hidden]

  MUSICKEYS = %w(A A# B B# C D D# E F F# G G#)
  SCALES = %w(Major Minor Blues)
  TIME_SIGNATURES = ['4/4', '3/4', '2/4', '3/8']

  def admin_users
    users.includes(:song_roles).where(song_roles: { role: 0 })
  end

  def follower_users
    users.includes(:song_roles).where(song_roles: { role: 1 })
  end

  def permissible_roles
    return [0, 2] unless hidden?
    []
  end

  private

  def create_song_role
    SongRole.create(user_id: creator_id, song_id: id, role: 1)
  end
end
