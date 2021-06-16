class AddIndexToSubCategories < ActiveRecord::Migration[6.1]
  def change
    add_index :sub_categories, :label, unique: true
  end
end
