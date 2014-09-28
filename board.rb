class Board
  attr_reader :pieces

  def initialize
    @pieces = []
  end

  def piece_at(location)
    pieces.find { |piece| piece.location == location }
  end

  def select_color(color)
    pieces.select { |piece| piece.color == color }
  end

  def take_piece(location)
    pieces.reject! { |piece| piece.location == location }
  end
end
