class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :area_id
      t.integer :tag_id
      t.timestamps null: false
    end
  end
end
