class Knight
  def self.can_move?(piece, board, desired_location)
    desired_indexes = Piece.location_to_array_indexes(desired_location)
    rank_difference = (piece.to_array_indexes[0] - desired_indexes[0]).abs
    file_difference = (piece.to_array_indexes[1] - desired_indexes[1]).abs
    difference = [rank_difference, file_difference]
    difference == [2, 1] || difference == [1, 2]
  end

  def self.can_take?(piece, board, desired_location)
    can_move?(piece, board, desired_location)
  end
end
