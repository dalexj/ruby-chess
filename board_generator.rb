require_relative 'piece'
require_relative 'board'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'

class BoardGenerator

  def create
    @board = Board.new
    set_pieces
    @board
  end

  def set_pieces
    set_back_row(:black, 8)
    set_pawns(:black, 7)
    set_pawns(:white, 2)
    set_back_row(:white, 1)
  end

  def set_pawns(color, rank)
    ("A".."H").each do |file|
      pawn = Pawn.new(color, "#{file}#{rank}")
      @board << pawn
    end
  end

  def set_back_row(color, rank)
    order = ("A".."H").to_a.zip(
      [:Rook, :Knight, :Bishop, :Queen, :King, :Bishop, :Knight, :Rook])
    order.each do |pair|
      file = pair[0]
      piece_type = Kernel.const_get(pair[1])
      piece = piece_type.new(color, "#{file}#{rank}")
      @board << piece
    end
  end
end
