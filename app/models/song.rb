# == Schema Information
#
# Table name: songs
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  music_key   :string
#  tempo       :integer
#  composer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Song < ApplicationRecord
  belongs_to :user
  belongs_to :composer
  has_many :song_resources
  has_many :resources, through: :song_resources
end
