module Calculations
  def location_difference(location_one, location_two)
    location_one.chars.zip(location_two.chars).collect do |pair|
      pair.collect(&:ord).reduce(:-)
    end
  end

  def squares_between(location_one, location_two)
    squares_between_row(location_one, location_two) ||
    squares_between_diagonal(location_one, location_two)
  end

  def squares_between_row(location_one, location_two)
    row = location_one =~ Regexp.new("[#{location_two}]")
    return if row.nil?
    range = range_bewteen(location_one[1 - row], location_two[1 - row])
    squares = range.collect { |col| "#{col}#{location_one[row]}" }
    squares.collect!(&:reverse) if row == 0
    squares[1..-2]
  end

  def range_bewteen(a, b)
    a > b ? (b..a) : (a..b)
  end

  def squares_between_diagonal(location_one, location_two)
    direction = to_diagonal(location_one, location_two)
    return if direction.nil?
    squares = []
    square = "#{location_one}"
    until squares[-1] == location_two
      square[0] = (square[0].ord + direction[0]).chr
      square[1] = (square[1].ord + direction[1]).chr
      squares << "#{square}"
    end
    squares[0..-2]
  end

  def to_diagonal(location_one, location_two)
    direction = location_difference(location_one, location_two)
    return nil unless direction.collect(&:abs).reduce(:==)
    direction.collect {|num| -(num / num.abs)}
  end

  def board_squares
    ("A1".."H8").to_a.reject { |square| square =~ /\w[09]/ }
  end

  def square_next_to_king(king_location, rook_location)
    squares_between(king_location, rook_location).find do |square|
      location_difference(square, king_location)[0].abs == 1
    end
  end

  def correct_rook?(king_location, rook_location, desired_location)
    squares_between(king_location, rook_location).include?(desired_location)
  end

  def king_moving_two_spots?(king_location, desired_location)
    [2, 0] == location_difference(king_location, desired_location).collect(&:abs)
  end

  def spaces_moving_pawn(location, desired_location)
    spaces = location_difference(location, desired_location)[1]
    spaces *= -1 if color == :white
    spaces
  end

  def last_move_two_spaces?
    [0, 2] == location_difference(*@last_move).collect(&:abs)
  end
end
