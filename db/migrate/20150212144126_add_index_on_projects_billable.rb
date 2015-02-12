class AddIndexOnProjectsBillable < ActiveRecord::Migration
  def change
    add_index :projects, :billable
  end
end
