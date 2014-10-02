require_relative 'calculations'

class Rook < Piece
  def initialize(color, location)
    super(color, location)
  end

  def can_move?(desired_location)
    location =~ Regexp.new("[#{desired_location}]")
  end

  def can_take?(target_location)
    can_move?(target_location)
  end
end
