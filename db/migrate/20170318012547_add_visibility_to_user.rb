class AddVisibilityToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :visibility, :integer, default: 0
  end
end
