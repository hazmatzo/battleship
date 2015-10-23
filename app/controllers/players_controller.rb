class PlayersController < ApplicationController
  def show
    if !(Game.count > 0)
      create_game
    end

    current_player = Player.where(id: params['id']).take
    other_player = Player.where.not(id: params['id']).take

    @board1 = current_player.board.cells.as_json
    @board2 = other_player.board.cells.as_json

    respond_to do |format|
      format.html { render "show", :locals => { :otherPlayerId => other_player, :currentPlayerId => current_player } }
      format.json { render json: {"player": @board1, "opponent": @board2} }
    end
  end

  def update
  end

  private

  # This is all obviously a class and would be so much cleaner like that, 
  # but I built it first then didn't have time to refactor.
  # Game.new

  SHIPS = [5, 4, 3, 2, 2]

  def create_game
    game = Game.create

    player1 = build_player
    player2 = build_player

    game.players << player1
    game.players << player2
  end

  def build_player
    board = build_board
    player = Player.create
    player.board = board
    player
  end

  def build_board
    board = Board.create
    board_id = board.id
    add_cells(board_id)
    ships = create_ships(board_id)
    place_ships(board_id, ships)
    board
  end

  def add_cells(board_id)
    (1..10).each do |row|
      (1..10).each do |column|
        Cell.create(row: row, column: column, board_id: board_id)
      end
    end
  end

  def create_ships(board_id)
    ships = []
    SHIPS.each do |size|
      ships << Ship.create(size: size, board_id: board_id)
    end
    ships
  end

  def place_ships(board_id, ships)
    ships.each do |ship|
      ship_placed = false
      while !ship_placed
        row = pick_a_number
        column = pick_a_number
        direction = pick_a_direction
        ship_placed = place_ship(board_id, row, column, direction, ship)
      end
    end
  end

  def pick_a_number
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].shuffle.last
  end

  def pick_a_direction
    ["horizontal", "vertical"].shuffle.last
  end

  def place_ship(board_id, row, column, direction, ship)
    ship_size = ship.size
    no_conflict = true
    ship_placed = false
    cells = []

    if direction == "horizontal"
      if column + ship_size > 10
        no_conflict = false
      else
        cells = find_cells(board_id, row, column, ship_size, direction)
      end
    else
      if row + ship_size > 10
        no_conflict = false
      else
        cells = find_cells(board_id, row, column, ship_size, direction)
      end
    end
    
    no_conflict = all_empty?(cells)

    if no_conflict
      add_ship_to_board(cells, ship)
      ship_placed = true
    end

    ship_placed
  end

  def find_cells(board_id, row, column, size, direction)
    cells = []
    if direction == "vertical"
      (0..size-1).map do |num|
        new_row = row + num
        cells << Cell.where(board_id: board_id).where(row: new_row).where(column: column).take
      end
    else
      (0..size-1).map do |num|
        new_column = column + num
        cells << Cell.where(board_id: board_id).where(row: row).where(column: new_column).take
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
