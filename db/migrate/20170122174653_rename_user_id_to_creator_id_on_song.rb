class RenameUserIdToCreatorIdOnSong < ActiveRecord::Migration[5.0]
  def change
    rename_column :songs, :user_id, :creator_id
  end
end
