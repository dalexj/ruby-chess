require_relative '../move_rules'
require_relative 'calculations'

module King
  include Calculations

  def self.can_move?(piece, board, desired_location)
    return false unless can_take?(piece, board, desired_location)
    !in_check?(piece, board, desired_location)
  end

  def self.can_take?(piece, board, desired_location)
    differences = Calculations::location_difference(piece.location ,desired_location)
    differences[0].abs <= 1 && differences[1].abs <= 1
  end

  def self.in_check?(piece, board, location) 
    opponent_color = [:black, :white].reject { |color| color == piece.color }.first
    board.select_color(opponent_color).any? do |piece|
      Kernel.const_get(piece.piece_type.capitalize).can_take?(piece, board, location)
    end
  end
end