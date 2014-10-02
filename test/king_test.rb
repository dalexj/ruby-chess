require_relative 'test_helper'
require_relative '../lib/piece'
require_relative '../lib/pieces/king'

class KingTest < Minitest::Test
  def setup
    @king = King.new(:white, "E5")
  end

  def test_king_can_move_one_space
    assert @king.can_move?("E6")
    assert @king.can_move?("F4")
    assert @king.can_move?("D6")
    assert @king.can_move?("D5")
  end

  def test_king_can_move_only_one_space
    refute @king.can_move?("E3")
    refute @king.can_move?("E7")
    refute @king.can_move?("C5")
    refute @king.can_move?("G5")
  end

  def test_can_take_same_as_can_move
    refute @king.can_take?("E7")
    refute @king.can_take?("C5")
    assert @king.can_take?("F4")
    assert @king.can_take?("D6")
  end
end
