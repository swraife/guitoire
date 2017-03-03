# == Schema Information
#
# Table name: set_list_songs
#
#  id         :integer          not null, primary key
#  song_id    :integer
#  routine_id :integer
#  music_key  :string
#  tempo      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sort_value :integer
#

# left as set_list_song until decided what 'song' will be named
class SetListSong < ApplicationRecord
  belongs_to :routine
  belongs_to :song

  before_create :default_sort_value

  default_scope { order(:sort_value) }

  def default_sort_value
    return if sort_value
    self.sort_value = (routine.set_list_songs.pluck(:sort_value).max || 1) + 1000
  end
end
