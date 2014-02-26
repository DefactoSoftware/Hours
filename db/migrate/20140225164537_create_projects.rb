class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false, default: ""

      t.timestamps
    end
  end
end
