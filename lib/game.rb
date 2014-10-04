require_relative 'board_generator'
require_relative 'legal_move_checker'
require_relative 'pieces/calculations'

class Game
  include Calculations
  include LegalMoveChecker

  attr_reader :board, :turn

  def initialize(generator = BoardGenerator.new)
    @generator = generator
    restart
  end

  def restart
    @last_move = ["A1","A1"]
    @board = @generator.create
    @turn = :white
    select_kings
    select_rooks
  end

  def move(start_location, end_location)
    return unless [:black, :white].include?(turn)
    piece_to_move = board.piece_at(start_location)
    piece_taken = board.piece_at(end_location)
    return unless piece_to_move && turn == piece_to_move.color
    return if piece_to_move.location == end_location

    unless legal_move?(piece_to_move, end_location)
      puts "illegal move"
      return
    end
    if piece_taken
      puts "taking piece"
      board.take_piece(end_location)
    elsif can_en_passant?(piece_to_move, end_location)
      puts "taking piece"
      board.take_piece(@last_move[1])
    elsif can_castle?(piece_to_move, end_location)
      castle(piece_to_move, end_location)
    end
    piece_to_move.location = end_location
    piece_to_move.move
    change_turns
    @last_move = [start_location, end_location]
    queue_promote_pawn(piece_to_move)
  end

  def same_color?(piece, other_piece)
    other_piece && piece.color == other_piece.color
  end

  def get_legal_moves(piece)
    board_squares.select { |square| legal_move?(piece, square) }
  end

  def in_checkmate?(color)
    board.select_color(color).all? { |piece| get_legal_moves(piece).empty? }
  end

  def select_kings
    @kings = {white: board.piece_at("E1"), black: board.piece_at("E8")}
  end

  def select_rooks
    @rooks = {white: [board.piece_at("A1"), board.piece_at("H1")],
              black: [board.piece_at("A8"), board.piece_at("H8")]}
  end

  def change_turns
    @turn = other_color(turn)
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

  def queue_promote_pawn(pawn)
    return unless pawn.class == Pawn && ["8", "1"].include?(pawn.location[1])
    @turn = "#{other_color(turn)}_promotion".to_sym
  end

  def promote_pawn(new_piece_type)
    return unless turn.to_s.include?("promotion")
    @turn = turn.to_s.split("_")[0].to_sym
    board << new_piece_type.new(board.take_piece(@last_move[1]).color, @last_move[1])
    change_turns
  end

  def waiting_for_promotion?
    turn.to_s.include?("_promotion")
  end

end
