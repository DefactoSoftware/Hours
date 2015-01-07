class AddIndexOnEntriesDate < ActiveRecord::Migration
  def change
    add_index :entries, :date
  end
end
