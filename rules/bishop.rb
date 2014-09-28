require_relative 'calculations'

class Bishop
  include Calculations

  def self.can_move?(piece, board, desired_location)
    diagonal = to_diagonal(piece.location, desired_location)
    return false unless diagonal
    !piece_in_way?(piece, board, desired_location)
  end

  def self.piece_in_way?(piece, board, desired_location)
    squares_between(piece.location, desired_location).any? do |square|
      board.piece_at(square)
    end
  end

  def self.squares_between(location_one, location_two) # TODO: refactor
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
    direction = Calculations::location_difference(location_one, location_two)
    return nil unless direction.collect(&:abs).reduce(:==)
    direction.collect {|num| -(num / num.abs)}
  end

  def self.can_take?(piece, board, desired_location)
    can_move?(piece, board, desired_location)
  end
end
