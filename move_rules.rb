require_relative 'rules/rook'
require_relative 'rules/knight'

class MoveRules
  def self.legal_move?(piece, board, desired_location)
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)

    case piece.piece_type
    when :knight
      Knight.can_move?(piece, board, desired_location)
    when :rook
      Rook.can_move?(piece, board, desired_location)
    # when :bishop
    #   bishop_can_move?(piece, board, desired_location)
    else
      true
    end
  end

  def self.same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def self.bishop_can_move?(piece, board, desired_location)

  end

end

Rook
