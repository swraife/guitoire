class AddDefaultPerformerIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default_performer_id, :integer
  end
end
