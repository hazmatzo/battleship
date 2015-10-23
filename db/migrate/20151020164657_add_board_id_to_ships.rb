class AddBoardIdToShips < ActiveRecord::Migration
  def change
    add_column :ships, :board_id, :integer
  end
end
