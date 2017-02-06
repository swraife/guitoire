# == Schema Information
#
# Table name: plays
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  song_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Play < ApplicationRecord
  include PublicActivity::Model
  include TrackableAssociations

  tracked only: [:create], owner: :user, recipient: :song

  belongs_to :user
  belongs_to :song

  def create_flash_notice
    player_count = song.players.uniq.count
    other_players = player_count > 1 ? "and #{player_count - 1} others" : ''

    "Song Played! You #{other_players} have played this song #{song.plays.count} times!"
  end
end
