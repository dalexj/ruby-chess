require_relative 'test_helper'
require_relative '../lib/piece'
require_relative '../lib/pieces/pawn'

class PawnTest < Minitest::Test
  def setup
    @white_pawn = Pawn.new(:white, "E2")
    @black_pawn = Pawn.new(:black, "E7")
  end

  def test_pawn_can_move_one_or_two_first_move
    assert @white_pawn.can_move?("E3")
    assert @white_pawn.can_move?("E4")
    assert @black_pawn.can_move?("E5")
    assert @black_pawn.can_move?("E6")
  end

  def test_pawn_cant_move_diagonally
    refute @white_pawn.can_move?("D3")
    refute @white_pawn.can_move?("F3")
    refute @black_pawn.can_move?("D6")
    refute @black_pawn.can_move?("F6")
  end

  def test_pawn_cant_move_backwards
    refute @white_pawn.can_move?("E1")
    refute @black_pawn.can_move?("E8")
  end

  def test_pawn_moves_only_once_after_first_move
    @white_pawn.move
    @black_pawn.move
    assert @white_pawn.can_move?("E3")
    assert @black_pawn.can_move?("E6")
    refute @white_pawn.can_move?("E4")
    refute @black_pawn.can_move?("E5")
  end

  def test_pawn_can_take_diagonally
    assert @white_pawn.can_take?("D3")
    assert @white_pawn.can_take?("F3")
    assert @black_pawn.can_take?("D6")
    assert @black_pawn.can_take?("F6")
  end
end
