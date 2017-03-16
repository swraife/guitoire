# == Schema Information
#
# Table name: routine_roles
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  routine_id :integer
#  role       :integer          default("admin")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_type :string
#

class RoutineRole < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :routine

  enum role: [:admin]
end
