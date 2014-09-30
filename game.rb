require_relative 'piece'
require_relative 'board'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @turn = :white
    set_pieces
    select_kings
  end

  def set_pieces
    set_back_row(:black, 8)
    set_pawns(:black, 7)
    set_pawns(:white, 2)
    set_back_row(:white, 1)
  end

  def set_pawns(color, rank)
    ("A".."H").each do |file|
      pawn = Pawn.new(color, "#{file}#{rank}")
      board << pawn
    end
  end

  def set_back_row(color, rank)
    order = ("A".."H").to_a.zip(
      [:Rook, :Knight, :Bishop, :Queen, :King, :Bishop, :Knight, :Rook])
    order.each do |pair|
      file = pair[0]
      piece_type = Kernel.const_get(pair[1])
      piece = piece_type.new(color, "#{file}#{rank}")
      board << piece
    end
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
    piece_to_move.move
    piece_to_move.location = end_location
    @turn = [:black, :white].reject { |color| color == @turn }.first
  end

  def legal_move?(piece, desired_location)
    other_piece = board.piece_at(desired_location)
    return false if same_color?(piece, other_piece)
    return false unless piece.can_move?(board, desired_location)
    temp = piece.location
    piece.location = desired_location
    check = @kings[@turn].in_check?(board, @kings[@turn].location, desired_location)
    piece.location = temp
    !check
  end

  def same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def get_legal_moves(piece)
    board_squares.select { |square| legal_move?(piece, square) }
  end

  def board_squares
    ("A1".."H8").to_a.reject { |square| square =~ /\w[09]/ }
  end

  def select_kings
    @kings = {white: board.piece_at("E1"), black: board.piece_at("E8")}
  end

end
