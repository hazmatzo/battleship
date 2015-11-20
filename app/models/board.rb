class Board < ActiveRecord::Base
  belongs_to :player
  has_many :cells
  has_many :ships

  SHIPS = [5, 4, 3, 2, 2]

  def build
    add_cells(10)
    ships = create_ships
    place_ships(ships)
    self
  end

  def add_cells(num)
    (1..num).each do |row|
      (1..num).each do |column|
        Cell.create(row: row, column: column, board_id: id)
      end
    end
  end

  def create_ships
    SHIPS.map do |size|
      Ship.create(size: size, board_id: id)
    end
  end

  def place_ships(ships, random_instance=nil)
    random = random_instance || Random.new
    ships.each do |ship|
      size = ship.size
      # random starting point
      # check for overlapping
      # place horizontally first
      ship.cells << self.cells[random.rand(10), size]
    end
  end
end