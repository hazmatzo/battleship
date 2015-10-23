class Player < ActiveRecord::Base
  has_one :board
  has_many :ships, through: :board
end