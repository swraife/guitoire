class ChangeRoutineRoleUserToOwner < ActiveRecord::Migration[5.0]
  def change
    rename_column :routine_roles, :user_id, :owner_id
    add_column :routine_roles, :owner_type, :string
  end
end
