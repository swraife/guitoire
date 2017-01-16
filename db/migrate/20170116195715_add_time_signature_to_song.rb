class AddTimeSignatureToSong < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :time_signature, :string
  end
end
