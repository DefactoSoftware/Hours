class RemoveBudgetTypeFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :budget_type, :string
  end
end
