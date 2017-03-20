class AddVisibilityToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :visibility, :integer, default: 0
  end
end
