class AddEmailSettingsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email_settings, :jsonb
  end
end
