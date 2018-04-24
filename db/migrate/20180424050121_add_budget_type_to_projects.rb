class AddBudgetTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :budget_type, :string
  end
end
