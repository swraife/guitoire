# == Schema Information
#
# Table name: set_list_songs
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  set_list_id :integer
#  music_key   :string
#  tempo       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_value  :integer
#

class SetListSong < ApplicationRecord
  belongs_to :set_list
  belongs_to :song

  before_create :default_sort_value

  def default_sort_value
    return if sort_value
    self.sort_value = set_list.set_list_songs.pluck(:sort_value).max + 1000
  end
end
