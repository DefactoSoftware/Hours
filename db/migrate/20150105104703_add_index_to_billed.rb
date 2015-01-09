class AddIndexToBilled < ActiveRecord::Migration
  def change
    add_index(:entries, :billed)
  end
end
