class Rook
  def self.can_move?(piece, board, desired_location)
    row = piece.location =~ Regexp.new("[#{desired_location}]")
    return false unless row
    !piece_in_way?(piece, board, desired_location)
  end

  def self.piece_in_way?(piece, board, desired_location)
    squares_between(piece.location, desired_location).any? do |square|
      board.piece_at(square)
    end
  end

  def self.squares_between(location_one, location_two)
    row = location_one =~ Regexp.new("[#{location_two}]")
    return if row.nil?
    range = range_bewteen(location_one[1 - row], location_two[1 - row])
    squares = range.collect{|col| "#{col}#{location_one[row]}"}
    squares.collect!(&:reverse) if row == 0
    squares[1..-2]
  end

  def self.range_bewteen(a, b)
    a > b ? (b..a) : (a..b)
  end

end
