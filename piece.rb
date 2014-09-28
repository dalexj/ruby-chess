require 'gosu'

class Piece
  attr_reader :color, :piece_type
  attr_accessor :location

  def initialize(color, piece_type)
    @color = color
    @piece_type = piece_type
    @location = "A1"
  end

  def promote(type)
    @piece_type = type if piece_type == :pawn
  end

  def file_loc
    type = piece_type == :knight ? "n" : piece_type[0]
    color[0] + type
  end

  def move
    @moved = true
  end

  def moved?
    @moved
  end

  def to_array_indexes
    Piece.location_to_array_indexes(location)
  end

  def self.location_to_array_indexes(location)
    row = 8 - location[1].to_i
    col = location[0].ord - 65
    [row, col]
  end
end
