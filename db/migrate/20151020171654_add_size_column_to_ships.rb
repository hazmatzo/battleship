class AddSizeColumnToShips < ActiveRecord::Migration
  def change
    add_column :ships, :size, :integer
  end
end
