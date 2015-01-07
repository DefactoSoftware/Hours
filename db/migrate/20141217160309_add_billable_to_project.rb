class AddBillableToProject < ActiveRecord::Migration
  def change
    add_column :projects, :billable, :boolean, default: false
  end
end
