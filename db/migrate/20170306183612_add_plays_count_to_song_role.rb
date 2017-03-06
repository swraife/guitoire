class AddPlaysCountToSongRole < ActiveRecord::Migration[5.0]
  def change
    add_column :song_roles, :plays_count, :integer, default: 0
  end
end
