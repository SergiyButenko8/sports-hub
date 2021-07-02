class CreateSubCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_categories do |t|
      t.string :label
      t.boolean :hidden, default: false

      t.timestamps
    end
  end
end
