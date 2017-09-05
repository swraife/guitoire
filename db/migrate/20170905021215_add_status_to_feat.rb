class AddStatusToFeat < ActiveRecord::Migration[5.1]
  def change
    add_column :feats, :status, :integer, default: 0
  end
end
