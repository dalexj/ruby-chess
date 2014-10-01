require_relative 'board_generator'
require_relative 'legal_move_checker'
require_relative 'pieces/calculations'

class Game
  include Calculations
  include LegalMoveChecker

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
# =============================================================== REMOVE ONCE DONE TESTING
    return unless piece_to_move # && @turn == piece_to_move.color
    return if piece_to_move.location == end_location

    unless legal_move?(piece_to_move, end_location)
      puts "illegal move"
      return
    end

    if piece_taken
      puts "taking piece"
      board.take_piece(end_location)
    elsif can_castle?(piece_to_move, end_location)
      castle(piece_to_move, end_location)
    end
    piece_to_move.location = end_location
    piece_to_move.move
    change_turns
  end

  def same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def get_legal_moves(piece)
    board_squares.select { |square| legal_move?(piece, square) }
  end

  def in_checkmate?(color) # TODO: ALL OF THIS
  end

  def select_kings
    @kings = {white: board.piece_at("E1"), black: board.piece_at("E8")}
  end

  def select_rooks
    @rooks = {white: [board.piece_at("A1"), board.piece_at("H1")],
              black: [board.piece_at("A8"), board.piece_at("H8")]}
  end

  def change_turns
    @turn = other_color(@turn)
  end

  def other_color(your_color)
    [:black, :white].find { |color| color != your_color }
  end

  def castle(king, desired_location)
    puts "castling"
    rook = find_rook_can_castle(king, desired_location)
    rook.location = square_next_to_king(king.location, rook.location)
    rook.move
  end
end
