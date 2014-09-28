require_relative 'rules/rook'
require_relative 'rules/knight'
require_relative 'rules/bishop'
require_relative 'rules/queen'
require_relative 'rules/king'
require_relative 'rules/pawn'

class MoveRules
  def self.legal_move?(piece, board, desired_location)
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    Kernel.const_get(piece.piece_type.capitalize).can_move?(piece, board, desired_location)
  end

  def self.same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def self.board_squares
    ("A1".."H8").to_a.reject { |square| square =~ /\w[09]/ }
  end

  def self.print_legal_moves(piece, board)
    puts get_legal_moves(piece, board).join(" ")
  end

  def self.get_legal_moves(piece, board)
    board_squares.select { |square| legal_move?(piece, board, square) }
  end

end
