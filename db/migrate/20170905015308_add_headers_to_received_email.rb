class AddHeadersToReceivedEmail < ActiveRecord::Migration[5.1]
  def change
    add_column :received_emails, :headers, :jsonb
  end
end
