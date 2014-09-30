require_relative 'board_generator'

class Game
  attr_reader :board

  def initialize
    @board = BoardGenerator.new.create
    @turn = :white
    select_kings
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
    !check(piece, desired_location)
  end

  def check(piece, desired_location)
    temp = piece.location
    piece.location = desired_location
    check = @kings[@turn].in_check?(board, @kings[@turn].location, desired_location)
    piece.location = temp
  end

  def same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def get_legal_moves(piece)
    board_squares.select { |square| legal_move?(piece, square) }
  end

  def has_legal_moves?(color) # TODO: ALL OF THIS
  end

  def board_squares
    ("A1".."H8").to_a.reject { |square| square =~ /\w[09]/ }
  end

  def select_kings
    @kings = {white: board.piece_at("E1"), black: board.piece_at("E8")}
  end

end
