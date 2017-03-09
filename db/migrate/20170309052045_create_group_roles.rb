class CreateGroupRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :group_roles do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :status
      t.timestamps null: false
    end
  end
end
