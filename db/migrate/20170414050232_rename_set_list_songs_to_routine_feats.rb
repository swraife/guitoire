class RenameSetListSongsToRoutineFeats < ActiveRecord::Migration[5.0]
  def change
    rename_table :set_list_songs, :routine_feats
  end
end
