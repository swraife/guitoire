class CreateFriendships < ActiveRecord::Migration[5.0]
  def change
    create_table :friendships do |t|
      t.integer :connector_id
      t.integer :connected_id
      t.integer :status, default: 0
      t.datetime :accepted_at
      t.timestamps null: false
    end
  end
end
