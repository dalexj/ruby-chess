module LegalMoveChecker
  def legal_move?(piece, desired_location)
    return false if piece.location == desired_location
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    return false unless piece.can_move?(desired_location) # || can_castle?(piece, desired_location)
    # return false if still_in_check(piece, desired_location)
    return false if piece_in_way?(piece, desired_location)
    true
  end
end
