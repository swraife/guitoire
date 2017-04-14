class RenameSongToFeat < ActiveRecord::Migration[5.0]
  def change
    rename_table :songs, :feats
  end
end
