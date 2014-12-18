class AddArchivedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :archived, :bool, default: false, null: false
  end
end
