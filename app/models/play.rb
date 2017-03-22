# == Schema Information
#
# Table name: plays
#
#  id           :integer          not null, primary key
#  performer_id :integer
#  song_role_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Play < ApplicationRecord
  include PublicActivity::Model
  include TrackableAssociations

  default_scope { order("created_at DESC") }

  tracked only: [:create], owner: :performer, recipient: :song

  belongs_to :performer
  belongs_to :song_role, counter_cache: true

  has_one :song, through: :song_role

  # To be deleted once owner is made polymorphic
  def owner
    performer
  end

  def create_flash_notice
    player_count = song.players.count
    other_players = player_count > 1 ? "and #{player_count - 1} others" : ''

    "Song Played! You #{other_players} have played this song #{song.plays.count} times!"
  end

  def song
    song_role.song
  end

  def song_id
    song.id
  end
end
