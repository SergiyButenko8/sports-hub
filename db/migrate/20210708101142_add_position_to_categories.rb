class AddPositionToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :position, :integer, default: 1
  end
end
