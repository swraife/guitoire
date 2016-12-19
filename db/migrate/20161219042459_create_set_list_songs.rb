class CreateSetListSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :set_list_songs do |t|
      t.integer :song_id
      t.integer :set_list_id
      t.string :music_key
      t.integer :tempo

      t.timestamps null: false
    end
  end
end
