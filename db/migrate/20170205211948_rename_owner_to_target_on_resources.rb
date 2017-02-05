class RenameOwnerToTargetOnResources < ActiveRecord::Migration[5.0]
  def change
    rename_column :resources, :owner_id, :target_id
    rename_column :resources, :owner_type, :target_type
  end
end
