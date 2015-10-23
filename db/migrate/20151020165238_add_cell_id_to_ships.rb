class AddCellIdToShips < ActiveRecord::Migration
  def change
    add_column :ships, :cell_id, :integer
  end
end
