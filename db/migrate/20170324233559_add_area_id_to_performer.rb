class AddAreaIdToPerformer < ActiveRecord::Migration[5.0]
  def change
    add_column :performers, :area_id, :integer
  end
end
