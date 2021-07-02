class AddSubCategoryRefToTeams < ActiveRecord::Migration[6.1]
  def change
    add_reference :teams, :sub_category, foreign_key: true
  end
end
