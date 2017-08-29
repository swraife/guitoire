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
  include GlobalOwner
  include Resourceable

  belongs_to :owner, polymorphic: true
  belongs_to :routine

  enum role: [:admin]

  # TODO: Make sure prevents unauthorized resource adding to routines
  def has_edit_permission?
    persisted?
  end

  def redirect_target
    routine
  end
end
