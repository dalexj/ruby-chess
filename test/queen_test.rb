require_relative 'test_helper'
require_relative '../lib/piece'
require_relative '../lib/pieces/queen'

class QueenTest < Minitest::Test
  def setup
    @queen = Queen.new(:white, "E5")
  end

  def test_queen_moves_in_rows_and_columns
    assert @queen.can_move?("E8")
    assert @queen.can_move?("H5")
    assert @queen.can_move?("A5")
    assert @queen.can_move?("E1")
  end

  def test_places_queen_cant_move
    refute @queen.can_move?("F8")
    refute @queen.can_move?("F7")
    refute @queen.can_move?("D2")
    refute @queen.can_move?("A6")
  end

  def test_queen_takes_in_rows_and_columns_and_diagonals
    assert @queen.can_take?("E8")
    assert @queen.can_take?("A1")
    assert @queen.can_take?("B8")
    refute @queen.can_take?("A2")
    refute @queen.can_take?("B7")
  end

  def test_queen_can_move_diagonally
    assert @queen.can_move?("A1")
    assert @queen.can_move?("H8")
    assert @queen.can_move?("H2")
    assert @queen.can_move?("B8")
  end
end
