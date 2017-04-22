class ChangeSettingsOnPerformers < ActiveRecord::Migration[5.0]
  def change
    change_column :performers, :settings, :jsonb, default: {}
  end
end
