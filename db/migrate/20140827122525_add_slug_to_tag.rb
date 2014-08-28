class AddSlugToTag < ActiveRecord::Migration
  def change
    add_column :tags, :slug, :string
    add_index :tags, :slug

    Tag.find_each(&:save)
  end
end
