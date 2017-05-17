class RenameUserMessageThreadsToPerformerMessageThreads < ActiveRecord::Migration[5.1]
  def change
    rename_table :user_message_threads, :performer_message_threads
  end
end
