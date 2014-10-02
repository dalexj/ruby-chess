require_relative 'test_helper'
require_relative '../lib/piece'
require_relative '../lib/pieces/knight'

class KnightTest < Minitest::Test
  def setup
    @knight = Knight.new(:white, "E5")
  end

  def test_knight_moves_correctly
    assert @knight.can_move?("D7")
    assert @knight.can_move?("G4")
    assert @knight.can_move?("C6")
    assert @knight.can_move?("F3")
  end

  def test_king_can_move_only_one_space
    refute @knight.can_move?("A1")
    refute @knight.can_move?("E4")
    refute @knight.can_move?("E8")
    refute @knight.can_move?("G5")
  end

  def test_can_take_same_as_can_move
    assert @knight.can_take?("D7")
    assert @knight.can_take?("F3")
    refute @knight.can_take?("A1")
    refute @knight.can_take?("E4")
  end
end
