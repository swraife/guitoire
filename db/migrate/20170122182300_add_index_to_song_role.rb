class AddIndexToSongRole < ActiveRecord::Migration[5.0]
  def change
    add_index :song_roles, [:user_id, :song_id], unique: true
  end
end
