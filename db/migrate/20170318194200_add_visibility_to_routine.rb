class AddVisibilityToRoutine < ActiveRecord::Migration[5.0]
  def change
    add_column :routines, :visibility, :integer, default: 0
  end
end
