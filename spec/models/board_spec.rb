require 'rails_helper'

describe Board do
  describe 'build' do
    before do
      @board = Board.create
      @board.build
    end

    it 'creates 100 cells' do
      expect(Cell.count).to be(100)
    end

    it 'cells are attached to the board' do
      expect(Cell.last.board_id).to be(@board.id)
    end

    it 'adds 1-10 row and column information to the cells' do
      expect(Cell.first.row).to be 1
      expect(Cell.first.column).to be 1

      expect(Cell.last.row).to be 10
      expect(Cell.last.column).to be 10
    end

    it 'creates 5 ships' do
      expect(Ship.count).to be(5)
    end

    it 'ships are attached to the board' do
      Ship.all.each do |ship|
        expect(ship.board_id).to be(@board.id)
      end
    end
  end

  describe 'place_ships' do
    before do
    end

    it 'places the ship on the board cells' do
      board = Board.create
      board.add_cells(10)
      ship = Ship.create(size: 3, board_id: board.id)
      board.place_ships([ship])

      expect(board.ships.take.cells.count).to eq 3
      expect(ship.cells.count).to eq 3
    end

    it 'places the ship on the board cells' do
      board = Board.create
      board.add_cells(10)
      ship = Ship.create(size: 2, board_id: board.id)
      board.place_ships([ship])

      expect(board.ships.take.cells.count).to eq 2
      expect(ship.cells.count).to eq 2
    end

    it 'doesnt overlap two ships' do
      board = Board.create
      random = double("Random")
      allow(random).to receive(:new)
      allow(random).to receive(:rand).and_return(1, 7)
      board.add_cells(10)
      ship1 = Ship.create(size: 2, board_id: board.id)
      ship2 = Ship.create(size: 3, board_id: board.id)
      ships = [ship2, ship1]
      board.place_ships(ships, random)

      expect(board.ships.count).to eq 2
      expect(ship2.cells.count).to eq ship2.size
      expect(ship1.cells.count).to eq ship1.size
    end
  end
end