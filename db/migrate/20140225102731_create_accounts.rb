class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subdomain, null: false, default: ""
      t.integer :owner_id, null: false, default: ""

      t.timestamps
    end
  end
end
