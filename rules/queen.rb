require_relative 'bishop'
require_relative 'rook'

class Queen
  def self.can_move?(piece, board, desired_location)
    Rook.can_move?(piece, board, desired_location) || Bishop.can_move?(piece, board, desired_location)
  end
end
