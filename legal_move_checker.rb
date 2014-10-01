module LegalMoveChecker

  def legal_move?(piece, desired_location)
    return false if piece.location == desired_location
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    if other_piece
      return false unless piece.can_take?(desired_location)
    else
      return false unless piece.can_move?(desired_location) || can_castle?(piece, desired_location)
    end
    return false if still_in_check(piece, desired_location)
    return false if piece_in_way?(piece, desired_location)
    true
  end

  def still_in_check(piece, desired_location)
    temp_location = piece.location
    piece.location = desired_location
    check = in_check?(piece.color, desired_location)
    piece.location = temp_location
    check
  end

  def in_check?(color, ignore_location)
    board.select_color(other_color(color)).any? do |piece|
      piece.can_take?(@kings[color].location) unless ignore_location == piece.location
    end
  end

  def can_castle?(king, desired_location)
    return false unless king.class == King
    rook_to_castle = find_rook_can_castle(king, desired_location)
    return false unless rook_to_castle && king_moving_two_spots?(king.location, desired_location)
    true
  end

  def find_rook_can_castle(king, desired_location)
    @rooks[king.color].find do |rook|
      !king.moved? && !rook.moved? &&
      correct_rook?(king.location, rook.location, desired_location)
    end
  end

  def piece_in_way?(piece, desired_location)
    return false unless [Rook, Bishop, Queen].include?(piece.class)
    squares_between(piece.location, desired_location).any? do |square|
      board.piece_at(square)
    end
  end
end
