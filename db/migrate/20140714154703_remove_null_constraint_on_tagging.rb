class RemoveNullConstraintOnTagging < ActiveRecord::Migration
  def change
    change_column :taggings, :entry_id, :integer, null: true
  end
end
