class FixSongRoleIndices < ActiveRecord::Migration[5.0]
  def change
    remove_index :song_roles, column: [:owner_id, :song_id]
    add_index :song_roles, [:song_id, :owner_id, :owner_type], unique: true
  end
end
