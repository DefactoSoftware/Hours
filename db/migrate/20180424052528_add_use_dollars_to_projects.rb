class AddUseDollarsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :use_dollars, :boolean, default: false
  end
end
