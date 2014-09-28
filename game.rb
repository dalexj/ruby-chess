require_relative 'piece'
require_relative 'board'
require_relative 'move_rules'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    set_pieces
  end

  def set_pieces
    set_back_row(:black, 8)
    set_pawns(:black, 7)
    set_pawns(:white, 2)
    set_back_row(:white, 1)
  end

  def set_pawns(color, rank)
    ("A".."H").each do |file|
      pawn = Piece.new(color, :pawn)
      pawn.location = "#{file}#{rank}"
      board.pieces << pawn
    end
  end

  def set_back_row(color, rank)
    order = ("A".."H").to_a.zip(
      [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook])
    order.each do |pair|
      file = pair[0]
      piece_type = pair[1]
      piece = Piece.new(color, piece_type)
      piece.location = "#{file}#{rank}"
      board.pieces << piece
    end
  end

  def move(start_location, end_location)
    piece_to_move = board.piece_at(start_location)
    piece_taken = board.piece_at(end_location)

    return if piece_to_move.nil? || start_location == end_location
    unless MoveRules.legal_move?(piece_to_move, board, end_location)
      puts "illegal move"
      return
    end

    if piece_taken
      puts "taking piece"
      board.take_piece(end_location)
    end
    piece_to_move.move
    piece_to_move.location = end_location
  end

end
