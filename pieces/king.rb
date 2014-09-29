require_relative 'calculations'

class King < Piece
  def can_move?(board, desired_location)
    return false unless can_take?(board, desired_location)
    !in_check?(board, desired_location)
  end

  def can_take?(board, desired_location)
    differences = Calculations.location_difference(location, desired_location)
    differences[0].abs <= 1 && differences[1].abs <= 1
  end

  def in_check?(board, location)
    opponent_color = [:black, :white].reject { |color| color == piece.color }.first
    board.select_color(opponent_color).any? do |piece|
      piece.can_take?(board, location)
    end
  end
end
