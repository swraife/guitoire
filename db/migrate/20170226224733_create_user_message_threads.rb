class CreateUserMessageThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :user_message_threads do |t|
      t.integer :user_id
      t.integer :message_thread_id
      t.timestamps null: false
    end
  end
end
