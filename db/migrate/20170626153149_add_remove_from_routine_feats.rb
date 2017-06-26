class AddRemoveFromRoutineFeats < ActiveRecord::Migration[5.1]
  def change
    remove_column :routine_feats, :tempo
    remove_column :routine_feats, :music_key
    add_column :routine_feats, :name, :string
    add_column :routine_feats, :description, :text
  end
end
