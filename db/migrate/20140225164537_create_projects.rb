class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false, default: ""
      t.references :account, index: true

      t.timestamps
    end
  end
end
