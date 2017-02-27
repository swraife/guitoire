class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :message_thread_id
      t.text :content
      t.timestamps null: false
    end
  end
end
