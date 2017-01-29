class DropSongResources < ActiveRecord::Migration[5.0]
  def change
    drop_table :song_resources
  end
end
