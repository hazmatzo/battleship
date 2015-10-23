class Cell < ActiveRecord::Base
  belongs_to :board
  has_one :ship
end