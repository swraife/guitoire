class RenameSetListIdToRoutineId < ActiveRecord::Migration[5.0]
  def change
    rename_column :set_list_songs, :set_list_id, :routine_id
  end
end
