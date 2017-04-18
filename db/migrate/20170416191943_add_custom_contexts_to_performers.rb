class AddCustomContextsToPerformers < ActiveRecord::Migration[5.0]
  def change
    add_column :performers, :context_settings, :jsonb, default: {}
  end
end
