class RenameConnectorAndConnectedColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :follows, :connector_id, :performer_id
    rename_column :follows, :connected_id, :follower_id
  end
end
