class AddArticlesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :image
      t.string :alt
      t.string :headline
      t.string :caption
      t.text :content
      t.boolean :published, default: false
      t.boolean :commented, default: true
      t.timestamps
    end
  end
end
