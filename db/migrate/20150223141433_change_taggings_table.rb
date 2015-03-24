class ChangeTaggingsTable < ActiveRecord::Migration
  def change
    remove_index :taggings, column: :entry_id

    rename_column :taggings, :entry_id, :hour_id

    add_index :taggings, :hour_id
  end
end
