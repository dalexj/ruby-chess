class MoveRules
  def self.legal_move?(piece, board, desired_location)
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)

    case piece.piece_type
    when :knight
      knight_can_move?(piece, board, desired_location)
    when :rook
      rook_can_move?(piece, board, desired_location)
    # when :bishop
    #   bishop_can_move?(piece, board, desired_location)
    else
      true
    end
  end

  def self.same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def self.knight_can_move?(piece, board, desired_location)
    desired_indexes = Piece.location_to_array_indexes(desired_location)
    rank_difference = (piece.to_array_indexes[0] - desired_indexes[0]).abs
    file_difference = (piece.to_array_indexes[1] - desired_indexes[1]).abs
    difference = [rank_difference, file_difference]
    difference == [2, 1] || difference == [1, 2]
  end

  def self.rook_can_move?(piece, board, desired_location)
    locations = piece.location.chars.zip(desired_location.chars)
    rank_on = locations.find { |pair| pair.reduce(:==) }
    return false if rank_on.nil?
    row = rank_on[0].to_i
    if row == 0 # matched an "A"
      piece_col = piece.location[1].to_i
      desired_col = desired_location[1].to_i

      spots_to_check = (piece_col + 1...desired_col).to_a == [] ?
        (desired_col + 1...piece_col).to_a : (piece_col + 1...desired_col).to_a
      puts spots_to_check
      spots_to_check.all? do |spot|
        board.piece_at("#{rank_on[0]}#{spot}").nil?
      end
    else # matched a "1"
      piece_col = piece.location[0].ord
      desired_col = desired_location[0].ord

      spots_to_check = ((piece_col + 1).chr...desired_col.chr).to_a == [] ?
        ((desired_col + 1).chr...piece_col.chr).to_a : ((piece_col + 1).chr...desired_col.chr).to_a
      puts spots_to_check
      spots_to_check.all? do |spot|
        board.piece_at("#{spot}#{rank_on[0]}").nil?
      end
    end
  end

  def self.bishop_can_move?(piece, board, desired_location)

  end

end
