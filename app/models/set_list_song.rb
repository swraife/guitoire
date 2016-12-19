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
#

class SetListSong < ApplicationRecord
end
