class AddsOwnerToSongRole < ActiveRecord::Migration[5.0]
  def change
    add_column :song_roles, :owner_type, :string
  end
end
