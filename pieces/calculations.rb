module Calculations
  def self.location_difference(location_one, location_two)
    location_one.chars.zip(location_two.chars).collect do |pair|
      pair.collect(&:ord).reduce(:-)
    end
  end

  def self.squares_between_row(location_one, location_two)
    row = location_one =~ Regexp.new("[#{location_two}]")
    return if row.nil?
    range = range_bewteen(location_one[1 - row], location_two[1 - row])
    squares = range.collect { |col| "#{col}#{location_one[row]}" }
    squares.collect!(&:reverse) if row == 0
    squares[1..-2]
  end

  def self.range_bewteen(a, b)
    a > b ? (b..a) : (a..b)
  end

  def self.squares_between_diagonal(location_one, location_two)
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

  def self.to_diagonal(location_one, location_two)
    direction = Calculations.location_difference(location_one, location_two)
    return nil unless direction.collect(&:abs).reduce(:==)
    direction.collect {|num| -(num / num.abs)}
  end

  def self.board_squares
    ("A1".."H8").to_a.reject { |square| square =~ /\w[09]/ }
  end
end
