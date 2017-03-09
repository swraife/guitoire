# == Schema Information
#
# Table name: group_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_id   :integer
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GroupRole < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum status: [:viewer, :admin]
end
