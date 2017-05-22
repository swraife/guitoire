class RenameConnectorAndConnectedColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :followers, :connector_id, :performer_id
    rename_column :followers, :connected_id, :follower_id
  end
end
