class CreateReceivedEmail < ActiveRecord::Migration[5.1]
  def change
    create_table :received_emails do |t|
      t.jsonb :to
      t.jsonb :from
      t.text :body
      t.text :subject
      t.string :sender_type
      t.integer :sender_id
      t.timestamps null: false
    end
  end
end
