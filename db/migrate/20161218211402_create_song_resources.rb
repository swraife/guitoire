class CreateSongResources < ActiveRecord::Migration[5.0]
  def change
    create_table :song_resources do |t|
      t.integer :song_id
      t.integer :resource_id

      t.timestamps null: false
    end
  end
end
