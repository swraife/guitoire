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

require 'rails_helper'

RSpec.describe SetListSong, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
