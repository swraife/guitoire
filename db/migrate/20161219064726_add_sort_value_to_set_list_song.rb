class AddSortValueToSetListSong < ActiveRecord::Migration[5.0]
  def change
    add_column :set_list_songs, :sort_value, :integer
  end
end
