class ChangeEntryTableAndIndexes < ActiveRecord::Migration
  def change
    remove_index :entries, :billed
    remove_index :entries, :category_id
    remove_index :entries, :date
    remove_index :entries, :project_id
    remove_index :entries, :user_id

    rename_table :entries, :hours

    add_index :hours, :billed
    add_index :hours, :category_id
    add_index :hours, :date
    add_index :hours, :project_id
    add_index :hours, :user_id
  end
end
