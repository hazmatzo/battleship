class Ship < ActiveRecord::Base
  belongs_to :board
  has_many :cells
end