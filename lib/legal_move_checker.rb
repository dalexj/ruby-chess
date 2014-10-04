module LegalMoveChecker

  def legal_move?(piece, desired_location)
    return false if piece.location == desired_location
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    if other_piece
      return false unless piece.can_take?(desired_location)
    else
      return false unless piece.can_move?(desired_location) || can_castle?(piece, desired_location) || can_en_passant?(piece, desired_location)
    end
    return false if still_in_check?(piece, desired_location)
    return false if piece_in_way?(piece, desired_location)
    true
  end

  def still_in_check?(piece, desired_location)
    temp_location = piece.location
    piece.location = desired_location
    check = in_check?(piece.color, desired_location)
    piece.location = temp_location
    check
  end

  def in_check?(color, ignore_location = "")
    board.select_color(other_color(color)).any? do |piece|
      unless ignore_location == piece.location || piece_in_way?(piece, @kings[color].location)
        piece.can_take?(@kings[color].location)
      end
    end
  end

  def can_castle?(king, desired_location)
    return false unless king.class == King
    rook_to_castle = find_rook_can_castle(king, desired_location)
    return false unless rook_to_castle && king_moving_two_spots?(king.location, desired_location)
    return false if in_check?(king.color)
    squares_between(king.location, rook_to_castle.location).none? do |square|
      still_in_check?(king, square) || board.piece_at(square)
    end
  end

  def find_rook_can_castle(king, desired_location)
    @rooks[king.color].find do |rook|
      !king.moved? && !rook.moved? &&
      correct_rook?(king.location, rook.location, desired_location)
    end
  end

  def piece_in_way?(piece, desired_location)
    return false unless [Rook, Bishop, Queen, Pawn].include?(piece.class)
    squares = squares_between(piece.location, desired_location)
    return unless squares
    squares.any? do |square|
      board.piece_at(square)
    end
  end

  def can_en_passant?(piece, desired_location)
    return false unless piece.class == Pawn
    return false unless last_move_two_spaces?
    return false unless piece.can_take?(desired_location)
    other_piece = board.piece_at(@last_move[1])
    return false unless other_piece.class == Pawn
    return false if other_piece.color == piece.color
    squares_between(*@last_move).include?(desired_location)
  end
end
