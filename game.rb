require_relative 'board_generator'
require_relative 'legal_move_checker'
require_relative 'pieces/calculations'

class Game
  include Calculations

  attr_reader :board

  def initialize
    # @move_checker = LegalMoveChecker.new
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

    return unless piece_to_move && @turn == piece_to_move.color
    return if piece_to_move.location == end_location

    unless legal_move?(piece_to_move, end_location)
      puts "illegal move"
      return
    end

    if piece_taken
      puts "taking piece"
      board.take_piece(end_location)
    # elsif can_castle?(piece, desired_location)
    #   castle(piece, desired_location)
    end
    piece_to_move.move
    piece_to_move.location = end_location
    change_turns
  end

  def legal_move?(piece, desired_location)
    return false if piece.location == desired_location
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    return false unless piece.can_move?(desired_location) # || can_castle?(piece, desired_location)
    # return false if still_in_check(piece, desired_location)
    return false if piece_in_way?(piece, desired_location)
    true
  end

  def still_in_check(piece, desired_location)
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
    board_squares.select { |square| legal_move?(piece, square) }
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

  def piece_in_way?(piece, desired_location)
    return false unless [Rook, Bishop, Queen].include?(piece.class)
    squares_between(piece.location, desired_location).any? do |square|
      board.piece_at(square)
    end
  end

  def change_turns
    @turn = [:black, :white].reject { |color| color == @turn }.first
  end

  def can_castle?(king, desired_location)
    return false unless king.class == King
    rook_to_castle = find_rook_can_castle(king, desired_location)
    return false unless rook_to_castle && king_moving_two_spots(king.location, desired_location)
    return false if in_check?(king, )
  end

  def find_rook_can_castle(king, desired_location)
    @rooks[king.color].find do |rook|
      !king.moved? && !rook.moved? &&
      correct_rook?(king.location, rook.location, desired_location)
    end
  end

  def castle(king, desired_location)

  end

  def in_check?(color)
    other_color(color)
  end

end
