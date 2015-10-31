class Boards
  attr_accessor :board, :board_id

  SHIPS = [5, 4, 3, 2, 2]

  def initialize
    @board = Board.create
    @board_id = @board.id
  end

  def build
    add_cells
    ships = create_ships
    place_ships(ships)
    @board
  end

  def add_cells
    (1..10).each do |row|
      (1..10).each do |column|
        Cell.create(row: row, column: column, board_id: @board_id)
      end
    end
  end

  def create_ships
    ships = []
    SHIPS.each do |size|
      ships << Ship.create(size: size, board_id: @board_id)
    end
    ships
  end

  def place_ships(ships)
    ships.each do |ship|
      ship_placed = false
      while !ship_placed
        row = pick_a_number
        column = pick_a_number
        direction = pick_a_direction
        ship_placed = place_ship(row, column, direction, ship)
      end
    end
  end

  def pick_a_number
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].shuffle.last
  end

  def pick_a_direction
    ["horizontal", "vertical"].shuffle.last
  end

  def place_ship(row, column, direction, ship)
    ship_size = ship.size
    no_conflict = true
    ship_placed = false
    cells = []

    if direction == "horizontal"
      if column + ship_size > 10
        no_conflict = false
      else
        cells = find_cells(row, column, ship_size, direction)
      end
    else
      if row + ship_size > 10
        no_conflict = false
      else
        cells = find_cells(row, column, ship_size, direction)
      end
    end
    
    no_conflict = all_empty?(cells)

    if no_conflict
      add_ship_to_board(cells, ship)
      ship_placed = true
    end

    ship_placed
  end

  def find_cells(row, column, size, direction)
    cells = []
    if direction == "vertical"
      (0..size-1).map do |num|
        new_row = row + num
        cells << Cell.where(board_id: @board_id).where(row: new_row).where(column: column).take
      end
    else
      (0..size-1).map do |num|
        new_column = column + num
        cells << Cell.where(board_id: @board_id).where(row: row).where(column: new_column).take
      end
    end
    cells
  end

  def all_empty?(cells)
    all_empty = true
    cells.each do |cell|
      if cell.ship != nil
        all_empty = false
      end
    end
    all_empty
  end

  def add_ship_to_board(cells, ship)
    cells.each do |cell|
      cell.ship = ship
      ship.cells << cell
    end
  end

end