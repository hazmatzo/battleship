class AddPlayerIdToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :player_id, :integer
  end
end
