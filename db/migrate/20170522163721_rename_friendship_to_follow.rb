class RenameFriendshipToFollow < ActiveRecord::Migration[5.1]
  def change
    rename_table :friendships, :follows
  end
end
