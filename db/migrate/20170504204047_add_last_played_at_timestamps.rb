class AddLastPlayedAtTimestamps < ActiveRecord::Migration[5.0]
  def change
    add_column :feat_roles, :last_played_at, :datetime
    add_column :feats, :last_played_at, :datetime
  end
end
