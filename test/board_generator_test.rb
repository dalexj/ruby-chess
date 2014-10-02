require_relative 'test_helper'
require_relative '../lib/board_generator'

class BoardGeneratorTest < Minitest::Test
  def setup
    @board = BoardGenerator.new.create
  end

  def test_places_all_pawns
    ("A".."H").each do |col|
      assert_equal Pawn, @board.piece_at("#{col}2").class
      assert_equal Pawn, @board.piece_at("#{col}7").class
    end
  end

  def test_places_back_row
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    ("A".."H").each_with_index do |col, index|
      assert_equal pieces[index], @board.piece_at("#{col}1").class
      assert_equal pieces[index], @board.piece_at("#{col}8").class
    end
  end
end
