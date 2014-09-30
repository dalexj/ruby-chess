require_relative 'calculations'

class Rook < Piece
  def initialize(color, location)
    super(color, location)
  end

  def can_move?(board, desired_location)
    return false if desired_location == location
    row = location =~ Regexp.new("[#{desired_location}]")
    return false unless row
    !piece_in_way?(board, desired_location)
  end

  def piece_in_way?(board, desired_location)
    Calculations.squares_between_row(location, desired_location).any? do |square|
      board.piece_at(square)
    end
  end

  def can_take?(board, desired_location)
    can_move?(board, desired_location)
  end
end
