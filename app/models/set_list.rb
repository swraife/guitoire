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

  has_many :set_list_users
  has_many :users, through: :set_list_users
end
