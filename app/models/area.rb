# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Area < ApplicationRecord
  has_many :performers
  has_many :skills

  has_many :tags, through: :skills

  DEFAULT_FEAT_NAMES = {
    1 => 'move',
    2 => 'move',
    3 => 'song',
    4 => 'skill'
  }
end
