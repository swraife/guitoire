class RenameSongIdsToFeatIds < ActiveRecord::Migration[5.0]
  def change
    rename_column :feat_roles, :song_id, :feat_id
    rename_column :plays, :song_role_id, :feat_role_id
    rename_column :routine_feats, :song_id, :feat_id
  end
end
