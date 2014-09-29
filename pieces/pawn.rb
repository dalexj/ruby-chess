class Pawn < Piece
  def initialize(color, location)
    super(color, :pawn, location)
  end

  def can_move?(board, desired_location)
    spaces = spaces_sideways(desired_location)
    if spaces == 0
      can_move_forward?(board, desired_location)
    elsif spaces == 1
      can_take?(board, desired_location) && board.piece_at(desired_location)
    end
  end

  def can_move_forward?(board, desired_location)
    return false if board.piece_at(desired_location)
    return false unless spaces_sideways(desired_location) == 0
    spaces = spaces_moving(desired_location)
    spaces == 1 || (!moved? && spaces == 2)
  end

  def can_take?(board, desired_location)
    spaces_moving(desired_location) == 1 && spaces_sideways(desired_location) == 1
  end

  def spaces_moving(desired_location)
    spaces_moving = location[1].to_i - desired_location[1].to_i
    spaces_moving *= -1 if color == :white
    spaces_moving
  end

  def spaces_sideways(desired_location)
    (location[0].ord - desired_location[0].ord).abs
  end
end
