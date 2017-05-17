class RenameUserToPerformerOnMessage < ActiveRecord::Migration[5.1]
  def change
    rename_column :messages, :user_id, :performer_id
    rename_column :user_message_threads, :user_id, :performer_id
    rename_column :message_copies, :user_id, :performer_id
  end
end
