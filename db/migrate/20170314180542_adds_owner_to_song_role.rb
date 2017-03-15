class AddsOwnerToSongRole < ActiveRecord::Migration[5.0]
  def change
    rename_column :song_roles, :user_id, :owner_id
    add_column :song_roles, :owner_type, :string
  end
end
