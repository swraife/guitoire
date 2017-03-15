class AddDefaultToRoutineRolesRole < ActiveRecord::Migration[5.0]
  def change
    change_column :routine_roles, :role, :integer, default: 0
  end
end
