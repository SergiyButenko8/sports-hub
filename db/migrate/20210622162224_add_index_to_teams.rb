class AddIndexToTeams < ActiveRecord::Migration[6.1]
  def change
    add_index :teams, :label, unique: true
  end
end
