class CreateClient < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false, default: ""
      t.string :description, default: ""
    end
  end
end
