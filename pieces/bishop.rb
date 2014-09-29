require_relative 'calculations'

class Bishop < Piece
  def can_move?(board, desired_location)
    diagonal = to_diagonal(piece.location, desired_location)
    return false unless diagonal
    !piece_in_way?(piece, board, desired_location)
  end

  def piece_in_way?(board, desired_location)
    squares_between_diagonal(location, desired_location).any? do |square|
      board.piece_at(square)
    end
  end

  def can_take?(board, desired_location)
    can_move?(board, desired_location)
  end
end
