class Players
  attr_accessor :player

  def initialize
    @player = Player.create
  end

  def build
    board = build_board
    @player.board = board
  end

  def build_board
    Boards.new.build
  end
end