class Queen < Piece
  include Calculations
  def initialize(color, location)
    super(color, location)
  end

  def can_move?(desired_location)
    squares_between(location, desired_location)
  end

  def can_take?(desired_location)
    can_move?(desired_location)
  end
end
