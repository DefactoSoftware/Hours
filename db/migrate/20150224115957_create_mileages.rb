class CreateMileages < ActiveRecord::Migration
  def change
    create_table :mileages do |t|
      t.references :project, index: true, null: false
      t.references :user, index: true, null: false
      t.integer :value, null: false
      t.date :date, null: false
      t.boolean :billed, default: false

      t.timestamps
    end

    add_index(:mileages, :billed)
    add_index(:mileages, :date)
  end
end
