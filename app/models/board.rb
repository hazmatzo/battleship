class Board < ActiveRecord::Base
  belongs_to :player
  has_many :cells
  has_many :ships
end