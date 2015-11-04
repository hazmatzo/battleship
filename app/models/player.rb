class Player < ActiveRecord::Base
  has_one :board
  has_many :ships, through: :board

  def build
    self.board = Boards.create.build
  end
end