class CreateSetListUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :set_list_users do |t|
      t.integer :user_id
      t.integer :set_list_id
      t.integer :role

      t.timestamps
    end
  end
end
