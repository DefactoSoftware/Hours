class AddBilledToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :billed, :boolean
  end
end
