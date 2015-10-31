class Games
  attr_accessor :game 

  def initialize
    @game = Game.create
  end

  def create_game
    player1 = build_player
    player2 = build_player

    @game.players << player1
    @game.players << player2
  end

  def build_player
    player = Players.new
    player.build
    player.player
  end
end