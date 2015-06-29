class AddSubscriptionIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :subscription_id, :string
  end
end
