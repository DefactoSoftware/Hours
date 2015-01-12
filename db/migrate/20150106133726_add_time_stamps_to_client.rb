class AddTimeStampsToClient < ActiveRecord::Migration
  def change
    add_column(:clients, :created_at, :datetime)
    add_column(:clients, :updated_at, :datetime)
  end
end
