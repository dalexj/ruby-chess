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

  # def in_check?(board, square = location, ignored_location = nil)
  #   opponent_color = [:black, :white].reject { |c| c == color }.first
  #   board.select_color(opponent_color).any? do |piece|
  #     piece.can_take?(board, square) unless ignored_location == piece.location
  #   end
  # end
  #
  # def can_castle?(board, rook_location)
  #   rook = board.piece_at(rook_location)
  #   return false if rook.nil? || moved? || rook.moved? || in_check?(board)
  #   squares = Calculations.squares_between_row(location, rook_location)
  #
  #   squares.none? { |square| in_check?(board, square) || board.piece_at(square) }
  # end

end
