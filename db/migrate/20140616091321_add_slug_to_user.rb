class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug

    User.find_each(&:save) # set the slugs on existing users
  end
end
