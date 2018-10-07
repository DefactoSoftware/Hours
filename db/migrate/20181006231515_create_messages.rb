class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :name
      t.string :email
      t.text :body

      t.timestamps null: false
    end
  end
end
