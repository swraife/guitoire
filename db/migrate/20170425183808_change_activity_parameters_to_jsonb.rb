class ChangeActivityParametersToJsonb < ActiveRecord::Migration[5.0]
  def change
    remove_column :activities, :parameters
    add_column :activities, :parameters, :jsonb, default: {}
  end
end
