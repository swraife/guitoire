class RenameSetListToRoutine < ActiveRecord::Migration[5.0]
  def change
    rename_table :set_lists, :routines
  end
end
