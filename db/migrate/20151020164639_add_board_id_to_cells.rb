class AddBoardIdToCells < ActiveRecord::Migration
  def change
    add_column :cells, :board_id, :integer
  end
end
