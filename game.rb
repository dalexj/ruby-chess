require_relative 'board_generator'
require_relative 'pieces/calculations'

class Game
  attr_reader :board

  def initialize
    restart
  end

  def restart
    @board = BoardGenerator.new.create
    @turn = :white
    select_kings
    select_rooks
  end

  def move(start_location, end_location)
    piece_to_move = board.piece_at(start_location)
    piece_taken = board.piece_at(end_location)

    return if piece_to_move.nil? || start_location == end_location
    return unless @turn == piece_to_move.color
    unless legal_move?(piece_to_move, end_location)
      puts "illegal move"
      return
    end

    if piece_taken
      puts "taking piece"
      board.take_piece(end_location)
    end
    rook = can_castle?(piece_to_move, end_location)
    if rook
      rook.location = Calculations.squares_between_row(piece_to_move.location, end_location)[0]
    end
    piece_to_move.move
    piece_to_move.location = end_location
    @turn = [:black, :white].reject { |color| color == @turn }.first
  end

  def legal_move?(piece, desired_location)
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    return false unless piece.can_move?(board, desired_location) || can_castle?(piece, desired_location)
    return false if check(piece, desired_location)
    true
  end

  def check(piece, desired_location)
    temp = piece.location
    piece.location = desired_location
    check = @kings[@turn].in_check?(board, @kings[@turn].location, desired_location)
    piece.location = temp
    check
  end

  def same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def get_legal_moves(piece)
    Calculations.board_squares.select { |square| legal_move?(piece, square) }
  end

  def has_legal_moves?(color) # TODO: ALL OF THIS
  end

  def select_kings
    @kings = {white: board.piece_at("E1"), black: board.piece_at("E8")}
  end

  def select_rooks
    @rooks = {white: [board.piece_at("A1"), board.piece_at("H1")],
              black: [board.piece_at("A8"), board.piece_at("H8")]}
  end

  def can_castle?(king, desired_location)
    return false unless king.class == King
    rook_to_castle = @rooks[king.color].find do |rook|
      king.can_castle?(board, rook.location)
    end
    return false unless rook_to_castle
    rook_to_castle if [2, 0] == Calculations.location_difference(king.location, desired_location).collect(&:abs)
  end

end
