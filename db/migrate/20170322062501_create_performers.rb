class CreatePerformers < ActiveRecord::Migration[5.0]
  def change
    create_table :performers do |t|
      t.integer :user_id
      t.string :name
      t.string :public_name
      t.attachment :avatar
      t.text :description
      t.string :email
      t.integer :visibility, default: 0
      t.jsonb :settings
      t.timestamps null: false
    end
  end
end
