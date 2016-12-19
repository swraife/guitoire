class CreateNoteResources < ActiveRecord::Migration[5.0]
  def change
    create_table :note_resources do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
