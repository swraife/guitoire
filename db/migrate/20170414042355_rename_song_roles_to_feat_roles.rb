class RenameSongRolesToFeatRoles < ActiveRecord::Migration[5.0]
  def change
    rename_table :song_roles, :feat_roles
  end
end
