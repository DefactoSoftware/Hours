class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :project, index: true, null: false
      t.references :category, index: true, null: false
      t.references :user, index: true, null: false
      t.integer :hours, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
