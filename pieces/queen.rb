require_relative 'bishop'
require_relative 'rook'

class Queen < Piece
  def can_move?(board, desired_location)
    [Rook, Bishop].any? { |a| a.new(color, :queen, location).can_move?(board, desired_location) }
  end

  def can_take?(board, desired_location)
    can_move?(board, desired_location)
  end
end
