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
    pieces.delete_at pieces.index{ |piece| piece.location == location }
  end

  def << (piece)
    pieces << piece
  end
end
