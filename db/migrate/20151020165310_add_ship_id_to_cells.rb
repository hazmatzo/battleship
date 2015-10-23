class AddShipIdToCells < ActiveRecord::Migration
  def change
    add_column :cells, :ship_id, :integer
  end
end
