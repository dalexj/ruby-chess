require_relative 'piece'

class Board

  attr_reader :pieces

  def initialize
    @pieces = []
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
      pawn.place_at("#{file}#{rank}")
      @pieces << pawn
    end
  end

  def set_back_row(color, rank)
    order = ("A".."H").to_a.zip([:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook])
    order.each do |pair|
      file = pair[0]
      piece_type = pair[1]
      piece = Piece.new(color, piece_type)
      piece.place_at("#{file}#{rank}")
      @pieces << piece
    end
  end

  def piece_at(location)
    pieces.find { |piece| piece.location == location }
  end

  def take_piece(location)
    pieces.reject! { |piece| piece.location == location }
  end

end
