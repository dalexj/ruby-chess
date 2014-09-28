class Pawn
  def self.can_move?(piece, board, desired_location)
    spaces = spaces_sideways(piece.location, desired_location)
    if spaces == 0
      can_move_forward?(piece, board, desired_location)
    elsif spaces == 1
      can_take?(piece, board, desired_location)
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
    spaces == 1 && board.piece_at(desired_location)
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
