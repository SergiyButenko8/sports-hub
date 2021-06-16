class AddPositionToSubCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :sub_categories, :position, :integer, default: 1
  end
end
