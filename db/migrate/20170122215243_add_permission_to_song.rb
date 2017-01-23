class AddPermissionToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :permission, :integer, default: 0
  end
end
