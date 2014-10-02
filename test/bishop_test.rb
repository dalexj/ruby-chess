require_relative 'test_helper'
require_relative '../lib/piece'
require_relative '../lib/pieces/bishop'

class BishopTest < Minitest::Test
  def setup
    @bishop = Bishop.new(:white, "E5")
  end

  def test_can_move_diagonally
    assert @bishop.can_move?("A1")
    assert @bishop.can_move?("H8")
    assert @bishop.can_move?("H2")
    assert @bishop.can_move?("B8")
  end

  def test_can_move_only_diagonally
    refute @bishop.can_move?("A2")
    refute @bishop.can_move?("H7")
    refute @bishop.can_move?("H3")
    refute @bishop.can_move?("B7")
  end

  def test_can_take_same_as_can_move
    assert @bishop.can_take?("A1")
    assert @bishop.can_take?("H8")
    assert @bishop.can_take?("H2")
    assert @bishop.can_take?("B8")
    refute @bishop.can_take?("A2")
    refute @bishop.can_take?("H7")
    refute @bishop.can_take?("H3")
    refute @bishop.can_take?("B7")
  end
end
