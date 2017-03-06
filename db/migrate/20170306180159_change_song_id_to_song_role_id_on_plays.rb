class ChangeSongIdToSongRoleIdOnPlays < ActiveRecord::Migration[5.0]
  def change
    rename_column :plays, :song_id, :song_role_id
  end
end
