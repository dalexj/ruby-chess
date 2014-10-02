require_relative 'calculations'

class King < Piece
  include Calculations

  def initialize(color, location)
    super(color, location)
  end

  def can_move?(desired_location)
    location_difference(location, desired_location).all? do |diff|
      diff.abs <= 1
    end
  end

  def can_take?(target_location)
    can_move?(target_location)
  end
end
