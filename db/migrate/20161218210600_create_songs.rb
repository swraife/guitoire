class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :name
      t.text :description
      t.string :music_key
      t.integer :tempo
      t.integer :composer_id

      t.timestamps null: false
    end
  end
end
