class AddPositionToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :position, :integer, default: 1
  end
end
