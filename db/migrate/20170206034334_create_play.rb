class CreatePlay < ActiveRecord::Migration[5.0]
  def change
    create_table :plays do |t|
      t.integer :user_id
      t.integer :song_id
      t.timestamps null: false
    end
  end
end
