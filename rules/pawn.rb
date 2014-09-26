class Pawn
  def self.can_move?(piece, board, desired_location)
    spaces_sideways = (piece.location[0].ord - desired_location[0].ord).abs
    if spaces_sideways == 0
      can_move_forward?(piece, board, desired_location)
    elsif spaces_sideways == 1
      can_take?(piece, board, desired_location)
    end
  end

  def self.can_move_forward?(piece, board, desired_location)
    spaces = spaces_moving(piece, desired_location)
    return false if board.piece_at(desired_location)
    spaces == 1 || (!piece.moved? && spaces == 2)
  end

  def self.can_take?(piece, board, desired_location)
    spaces = spaces_moving(piece, desired_location)
    spaces == 1 && board.piece_at(desired_location)
  end

  def self.spaces_moving(piece, desired_location)
    spaces_moving = piece.location[1].to_i - desired_location[1].to_i
    spaces_moving *= -1 if piece.color == :white
    spaces_moving
  end

end
