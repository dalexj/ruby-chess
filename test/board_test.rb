require_relative 'test_helper'
require_relative '../lib/board'
require_relative '../lib/piece'
require 'stringio'

class BoardTest < Minitest::Test
  def test_empty_board_upon_initialize
    board = Board.new
    assert_equal [], board.pieces
  end

  def test_can_add_pieces
    board = Board.new
    board << Piece.new(:black, "A1")
    assert_equal 1, board.pieces.count
  end

  def test_can_add_multiple_pieces
    board = Board.new
    board << [Piece.new(:black, "A1")] * 7
    assert_equal 7, board.pieces.count
  end

  def test_can_find_piece_at_location
    board = Board.new
    piece = Piece.new(:black, "A1")
    board << piece
    assert_equal piece, board.piece_at("A1")
    assert_equal nil, board.piece_at("H7")
  end

  def test_can_select_all_of_one_color
    board = Board.new
    pieces = [Piece.new(:black, "A1"), Piece.new(:black, "H1")]
    board << pieces
    board << Piece.new(:white, "B4")
    assert_equal pieces, board.select_color(:black)
  end

  def test_can_take_piece_at_location
    board = Board.new
    board << Piece.new(:black, "A1")
    $stdout = StringIO.new
    board.take_piece("A1")
    $stdout = STDOUT  
    assert_equal 0, board.pieces.count
  end

end
