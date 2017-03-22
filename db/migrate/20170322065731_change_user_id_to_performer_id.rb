class ChangeUserIdToPerformerId < ActiveRecord::Migration[5.0]
  def change
    rename_column :group_roles, :user_id, :performer_id
    rename_column :plays, :user_id, :performer_id
  end
end
