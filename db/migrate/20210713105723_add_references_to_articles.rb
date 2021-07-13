class AddReferencesToArticles < ActiveRecord::Migration[6.1]
  def change
    add_reference :articles, :category, foreign_key: true
    add_reference :articles, :sub_category, foreign_key: true
    add_reference :articles, :team, foreign_key: true
  end
end
