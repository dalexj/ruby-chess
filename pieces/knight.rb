require_relative 'calculations'

class Knight < Piece
  def initialize(color, location)
    super(color, location)
  end

  def can_move?(board, desired_location)
    differences = Calculations.location_difference(location, desired_location).collect(&:abs)
    differences == [2, 1] || differences == [1, 2]
  end

  def can_take?(board, desired_location)
    can_move?(board, desired_location)
  end
end
