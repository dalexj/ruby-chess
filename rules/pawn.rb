require_relative '../piece'
require_relative '../board'

class Pawn
  def self.can_move?(piece, board, desired_location)
    spaces = spaces_sideways(piece.location, desired_location)
    if spaces == 0
      can_move_forward?(piece, board, desired_location)
    elsif spaces == 1
      can_take?(piece, board, desired_location) && board.piece_at(desired_location)
    end
  end

  def self.can_move_forward?(piece, board, desired_location)
    return false unless spaces_sideways(piece.location, desired_location) == 0
    spaces = spaces_moving(piece, desired_location)
    return false if board.piece_at(desired_location)
    spaces == 1 || (!piece.moved? && spaces == 2)
  end

  def self.can_take?(piece, board, desired_location)
    return false unless spaces_sideways(piece.location, desired_location) == 1
    spaces = spaces_moving(piece, desired_location)
    spaces == 1
  end

  def self.spaces_moving(piece, desired_location)
    spaces_moving = piece.location[1].to_i - desired_location[1].to_i
    spaces_moving *= -1 if piece.color == :white
    spaces_moving
  end

  def self.spaces_sideways(location, desired_location)
    (location[0].ord - desired_location[0].ord).abs
  end
end

# board = Board.new
# king = Piece.new(:white, :king)
# king.location = "E5"
# pawn = Piece.new(:black, :pawn)
# pawn.location = "D7"
# board.pieces << king
# board.pieces << pawn
#
# Pawn.can_take?(pawn, board, "")
