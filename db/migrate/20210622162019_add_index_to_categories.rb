class AddIndexToCategories < ActiveRecord::Migration[6.1]
  def change
    add_index :categories, :label, unique: true
  end
end
