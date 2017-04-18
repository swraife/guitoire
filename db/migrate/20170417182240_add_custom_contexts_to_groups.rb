class AddCustomContextsToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :context_settings, :jsonb, default: {}
  end
end
