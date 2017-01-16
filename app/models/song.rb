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
#  user_id        :integer
#  scale          :string
#  time_signature :string
#

class Song < ApplicationRecord
  belongs_to :user
  belongs_to :composer
  has_many :song_resources
  has_many :resources, through: :song_resources

  accepts_nested_attributes_for :composer

  MUSICKEYS = %w(A A# B B# C D D# E F F# G G#)
  SCALES = %w(Major Minor Blues)
  TIME_SIGNATURES = ['4/4', '3/4', '2/4', '3/8']
end
