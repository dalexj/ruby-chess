class Knight < Piece
  include Calculations

  def initialize(color, location)
    super(color, location)
  end

  def can_move?(desired_location)
    differences = location_difference(location, desired_location).collect(&:abs)
    differences == [2, 1] || differences == [1, 2]
  end

  def can_take?(target_location)
    can_move?(target_location)
  end
end
