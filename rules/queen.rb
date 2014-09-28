require_relative 'bishop'
require_relative 'rook'

class Queen
  def self.can_move?(piece, board, desired_location)
    [Bishop, Rook].any? { |a| a.can_move?(piece, board, desired_location) }
  end

  def self.can_take?(piece, board, desired_location)
    can_move?(piece, board, desired_location)
  end
end
