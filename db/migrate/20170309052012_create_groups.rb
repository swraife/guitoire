class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.jsonb :settings
      t.attachment :avatar
      t.timestamps null: false
    end
  end
end
