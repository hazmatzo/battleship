class ChangeCellsColumnHidden < ActiveRecord::Migration
  def change
    change_column :cells, :hidden, :boolean
    change_column_default :cells, :hidden, true
  end
end
