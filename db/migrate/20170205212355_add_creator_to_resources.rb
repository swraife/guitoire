class AddCreatorToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :creator_type, :string
    add_column :resources, :creator_id, :integer

    add_index :resources, [:creator_type, :creator_id]
  end
end
