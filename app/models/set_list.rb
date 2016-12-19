# == Schema Information
#
# Table name: set_lists
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SetList < ApplicationRecord
  has_many :events
end
