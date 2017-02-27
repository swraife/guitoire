class CreateMessageCopies < ActiveRecord::Migration[5.0]
  def change
    create_table :message_copies do |t|
      t.integer :user_id
      t.integer :message_id
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
