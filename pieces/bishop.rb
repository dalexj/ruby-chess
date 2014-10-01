class Bishop < Piece
  include Calculations

  def initialize(color, location)
    super(color, location)
  end

  def can_move?(desired_location)
    to_diagonal(location, desired_location)
  end

  def can_take?(target_location)
    can_move?(target_location)
  end
end
