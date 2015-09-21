class AddLastUserActivityToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :user_activity, :date, default: DateTime.now
    add_index :projects, :user_activity
  end
end
