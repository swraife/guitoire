class CreateUrlResources < ActiveRecord::Migration[5.0]
  def change
    create_table :url_resources do |t|
      t.string :url

      t.timestamps null: false
    end
  end
end
