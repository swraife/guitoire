class RenameSetListUserToRoutineRole < ActiveRecord::Migration[5.0]
  def change
    rename_table :set_list_users, :routine_roles
    rename_column :routine_roles, :set_list_id, :routine_id
  end
end
