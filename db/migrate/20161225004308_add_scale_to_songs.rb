class AddScaleToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :scale, :string
  end
end
