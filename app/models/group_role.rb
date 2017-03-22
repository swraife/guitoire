# == Schema Information
#
# Table name: group_roles
#
#  id           :integer          not null, primary key
#  performer_id :integer
#  group_id     :integer
#  role         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class GroupRole < ApplicationRecord
  belongs_to :performer
  belongs_to :group

  enum role: [:viewer, :member, :admin]
end
