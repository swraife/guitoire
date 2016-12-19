class CreateFileResources < ActiveRecord::Migration[5.0]
  def change
    create_table :file_resources do |t|
      t.attachment :main

      t.timestamps null: false
    end
  end
end
