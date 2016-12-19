class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.references :resourceable, polymorphic: true

      t.timestamps null: false
    end
  end
end
