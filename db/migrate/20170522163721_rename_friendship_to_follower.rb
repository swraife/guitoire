class RenameFriendshipToFollower < ActiveRecord::Migration[5.1]
  def change
    rename_table :friendships, :followers
  end
end
