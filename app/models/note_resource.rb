# == Schema Information
#
# Table name: note_resources
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NoteResource < ApplicationRecord
  has_many :resources, as: :resourceable
end
