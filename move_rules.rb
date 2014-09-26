require_relative 'rules/rook'
require_relative 'rules/knight'
require_relative 'rules/bishop'
require_relative 'rules/queen'

class MoveRules
  def self.legal_move?(piece, board, desired_location)
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)

    case piece.piece_type
    when :knight
      Knight.can_move?(piece, board, desired_location)
    when :rook
      Rook.can_move?(piece, board, desired_location)
    when :bishop
      Bishop.can_move?(piece, board, desired_location)
    when :queen
      Queen.can_move?(piece, board, desired_location)
    else
      true
    end
  end

  def self.same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

end

Rook
