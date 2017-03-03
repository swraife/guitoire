class AddOwnerToRoutine < ActiveRecord::Migration[5.0]
  def change
    add_column :routines, :owner_id, :integer
    add_column :routines, :owner_type, :string
  end
end
