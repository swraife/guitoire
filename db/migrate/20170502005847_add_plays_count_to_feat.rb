class AddPlaysCountToFeat < ActiveRecord::Migration[5.0]
  def change
    add_column :feats, :plays_count, :integer, default: 0
    add_column :plays, :feat_id, :integer
  end
end
