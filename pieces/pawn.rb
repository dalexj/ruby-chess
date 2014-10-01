class Pawn < Piece
  include Calculations

  def initialize(color, location)
    super(color, location)
  end

  def can_move?(desired_location)
    spaces = spaces_sideways(desired_location)
    can_move_forward?(desired_location) && spaces == 0
  end

  def can_move_forward?(desired_location)
    return false unless spaces_sideways(desired_location) == 0
    spaces = spaces_moving_pawn(location, desired_location)
    spaces == 1 || (!moved? && spaces == 2)
  end

  def can_take?(desired_location)
    spaces_moving_pawn(location, desired_location) == 1 &&
    spaces_sideways(desired_location) == 1
  end

  def spaces_sideways(desired_location)
    (location[0].ord - desired_location[0].ord).abs
  end
end
