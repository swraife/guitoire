module RoutineRoleOwner
  extend ActiveSupport::Concern

  included do
    has_many :routine_roles, as: :owner
    has_many :routines, through: :routine_roles
    has_many :admin_routine_roles, -> { admin }, as: :owner, class_name: 'RoutineRole'
    has_many :routines_as_admin, through: :admin_routine_roles

    has_many :routines_as_owner, as: :owner, class_name: 'Routine'
  end
end
