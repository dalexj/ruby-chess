require_relative 'calculations'

class King < Piece
  def initialize(color, location)
    super(color, location)
  end

  def can_move?(board, desired_location)
    return false unless can_take?(board, desired_location)
    !in_check?(board, desired_location)
  end

  def can_take?(board, desired_location)
    differences = Calculations.location_difference(location, desired_location)
    differences[0].abs <= 1 && differences[1].abs <= 1
  end

  def in_check?(board, square = location, ignored_location = nil)
    opponent_color = [:black, :white].reject { |c| c == color }.first
    board.select_color(opponent_color).any? do |piece|
      piece.can_take?(board, square) unless ignored_location == piece.location
    end
  end

  def can_castle?(board, rook_location)
    rook = board.piece_at(rook_location)
    return false if rook.nil? || moved? || rook.moved? || in_check?(board)
    squares = Calculations.squares_between_row(location, rook_location)

    squares.none? { |square| in_check?(board, square) || board.piece_at(square) }
  end

end
