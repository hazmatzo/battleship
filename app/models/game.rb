class Game < ActiveRecord::Base
  has_many :players
  has_many :boards, through: :players

  def create_game
    self.players << build_player
    self.players << build_player
  end

  def build_player
    player = Player.create
    player.build
    player
  end
end