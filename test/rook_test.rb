require_relative 'test_helper'
require_relative '../lib/piece'
require_relative '../lib/pieces/rook'

class RookTest < Minitest::Test
  def setup
    @rook = Rook.new(:white, "E5")
  end

  def test_rook_moves_in_rows_and_columns
    assert @rook.can_move?("E8")
    assert @rook.can_move?("H5")
    assert @rook.can_move?("A5")
    assert @rook.can_move?("E1")
  end

  def test_rook_moves_only_in_rows_and_columns
    refute @rook.can_move?("F8")
    refute @rook.can_move?("F6")
    refute @rook.can_move?("D4")
    refute @rook.can_move?("A1")
  end

  def test_rook_takes_in_rows_and_columns
    assert @rook.can_take?("E8")
    assert @rook.can_take?("A5")
    refute @rook.can_take?("D4")
    refute @rook.can_take?("A1")
  end
end
