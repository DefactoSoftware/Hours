class ChangeHoursColumnToValue < ActiveRecord::Migration
  def change
    rename_column :hours, :hours, :value
  end
end
