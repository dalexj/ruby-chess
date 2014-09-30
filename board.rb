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
    index = pieces.index{ |piece| piece.location == location }
    pieces.delete_at index if index
  end

  def << (piece)
    pieces << piece
  end
end
