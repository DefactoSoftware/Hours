class AddClientReferenceToProject < ActiveRecord::Migration
  def change
    add_column :projects, :client_id, :integer
  end
end
