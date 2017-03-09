class RenameStatusToRoleOnGroupRole < ActiveRecord::Migration[5.0]
  def change
    rename_column :group_roles, :status, :role
  end
end
