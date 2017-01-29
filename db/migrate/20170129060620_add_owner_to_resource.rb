class AddOwnerToResource < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :owner_id, :integer
    add_column :resources, :owner_type, :string

    add_index :resources, [:owner_id, :owner_type]
  end
end
