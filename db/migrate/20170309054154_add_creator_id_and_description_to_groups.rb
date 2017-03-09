class AddCreatorIdAndDescriptionToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :creator_id, :integer
    add_column :groups, :description, :text
  end
end
