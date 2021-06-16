class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :label
      t.boolean :hidden, default: false

      t.timestamps
    end
  end
end
