class AddUsernameToPerformer < ActiveRecord::Migration[5.1]
  def change
    add_column :performers, :username, :string
    add_index :performers, :username, unique: true
  end
end
