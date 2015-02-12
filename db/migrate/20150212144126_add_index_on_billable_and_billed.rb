class AddIndexOnBillableAndBilled < ActiveRecord::Migration
  def change
    add_index :projects, :billable
    add_index :entry, :billed
  end
end
