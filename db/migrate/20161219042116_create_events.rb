class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.integer :set_list_id

      t.timestamps null: false
    end
  end
end
