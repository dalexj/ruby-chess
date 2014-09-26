require_relative 'bishop'

class King
  def self.can_move?(piece, board, desired_location)
    differences = Bishop.location_difference(piece.location ,desired_location)
    return false if differences[0].abs > 1 || differences[1].abs > 1
    !in_check?(board, desired_location)
  end

  def self.in_check?(board, location) # TODO: possible moves list for other color
    false
  end
end
