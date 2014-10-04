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
    set_pieces(Board.new)
  end

  def set_pieces(board)
    set_back_row(board, :black, 8)
    set_pawns(board, :black, 7)
    set_pawns(board, :white, 2)
    set_back_row(board, :white, 1)
    board
  end

  def set_pawns(board, color, rank)
    board << ("A".."H").collect do |file|
      Pawn.new(color, "#{file}#{rank}")
    end
  end

  def set_back_row(board, color, rank)
    order = ("A".."H").to_a.zip(
      [:Rook, :Knight, :Bishop, :Queen, :King, :Bishop, :Knight, :Rook])
    board << order.collect do |pair|
      Kernel.const_get(pair[1]).new(color, "#{pair[0]}#{rank}")
    end
  end
end
