require_relative 'board_generator'
require_relative 'legal_move_checker'
require_relative 'pieces/calculations'

class Game
  include Calculations

  attr_reader :board, :turn, :checker

  def initialize(generator = BoardGenerator.new)
    @generator = generator
    restart
  end

  def get_piece(location)
    board.piece_at(location) || NullPiece.new
  end

  def restart
    @board = @generator.create
    @checker = LegalMoveChecker.new(board)
    @turn = :white
  end

  def move(start_location, end_location)
    return unless your_move?(start_location, end_location)

    return puts "illegal move" unless checker.legal_move?(get_piece(start_location), end_location)

    take_piece(get_piece(start_location), end_location)

    castle(get_piece(start_location), end_location)
    get_piece(start_location).move
    get_piece(start_location).location = end_location
    change_turns
    checker.last_move = [start_location, end_location]
    queue_promote_pawn
  end

  def your_move?(start_location, end_location)
    start_location != end_location && turn == get_piece(start_location).color && (not waiting_for_promotion?)
  end

  def take_en_passant(piece, end_location)
    return unless checker.can_en_passant?(piece, end_location)
    board.take_piece(checker.last_move[1])
  end

  def get_legal_moves(piece)
    board_squares.select { |square| checker.legal_move?(piece, square) }
  end

  def in_checkmate?(color)
    board.select_color(color).all? { |piece| get_legal_moves(piece).empty? }
  end

  def change_turns
    @turn = other_color(turn)
  end

  def castle(king, desired_location)
    return unless checker.can_castle?(king, desired_location)
    puts "castling"
    rook = find_rook_can_castle(king, desired_location)
    rook.location = square_next_to_king(king.location, rook.location)
    rook.move
  end

  def queue_promote_pawn
    pawn = get_piece(checker.last_move[1])
    return unless pawn.class == Pawn && ["8", "1"].include?(pawn.location[1])
    @turn = "#{other_color(turn)}_promotion".to_sym
  end

  def promote_pawn(new_piece_type)
    return unless waiting_for_promotion?
    @turn = turn.to_s.split("_")[0].to_sym
    board.take_piece(checker.last_move[1])
    board << new_piece_type.new(turn, checker.last_move[1])
    change_turns
  end

  def take_piece(piece, end_location)
    board.take_piece(end_location)
    take_en_passant(piece, end_location)
  end

  def waiting_for_promotion?
    turn.to_s.include?("_promotion")
  end

end

class NullPiece
  def color
    :none
  end

  def location
    "Z0"
  end

  def move
    puts "fake piece"
  end
end
