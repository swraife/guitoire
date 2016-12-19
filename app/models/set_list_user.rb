# == Schema Information
#
# Table name: set_list_users
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  set_list_id :integer
#  role        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SetListUser < ApplicationRecord
  belongs_to :user
  belongs_to :set_list

  enum role: [:read, :write]
end
