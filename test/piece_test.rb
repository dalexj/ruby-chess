require_relative 'test_helper'
require_relative '../lib/piece'

class PieceTest < Minitest::Test
  def test_has_location_and_color
    piece_one = Piece.new(:black, "A1")
    piece_two = Piece.new(:white, "H8")

    assert_equal :black, piece_one.color
    assert_equal :white, piece_two.color
    assert_equal "A1", piece_one.location
    assert_equal "H8", piece_two.location
  end

  def test_gets_file_location
    piece = Piece.new(:black, "A1")
    assert_equal "bp", piece.file_loc
  end

  def test_array_indexes_converter
    assert_equal [0, 0], Piece.location_to_array_indexes("A8")
    assert_equal [6, 5], Piece.location_to_array_indexes("F2")
  end

  def test_moving_piece
    piece = Piece.new(:black, "A1")
    refute piece.moved?
    piece.move
    assert piece.moved?
  end


end
