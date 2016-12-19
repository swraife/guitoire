# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  date        :date
#  set_list_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :set_list
end
