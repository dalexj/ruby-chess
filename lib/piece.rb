class Piece
  attr_reader :color
  attr_accessor :location

  def initialize(color, location = "A1")
    @color = color
    @location = location
  end

  def file_loc # TODO: change to some piece_type method for each child
    type = self.class.to_s == "Knight" ? "n" : self.class.to_s[0].downcase
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
