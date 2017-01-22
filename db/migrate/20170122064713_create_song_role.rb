class CreateSongRole < ActiveRecord::Migration[5.0]
  def change
    create_table :song_roles do |t|
      t.integer :song_id
      t.integer :user_id
      t.integer :role, default: 0

      t.timestamps null: false
    end
  end
end
