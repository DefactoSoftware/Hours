class AddArchivedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :archived, :bool, default: false, null: false
    add_index :projects, :archived
  end
end
