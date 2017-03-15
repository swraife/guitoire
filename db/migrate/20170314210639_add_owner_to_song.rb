class AddOwnerToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :owner_id, :integer
    add_column :songs, :owner_type, :string
  end
end
