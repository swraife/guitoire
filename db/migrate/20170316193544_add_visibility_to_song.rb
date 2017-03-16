class AddVisibilityToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :visibility, :integer, default: 0
  end
end
