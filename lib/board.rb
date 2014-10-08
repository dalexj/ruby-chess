class Board
  attr_reader :pieces

  def initialize
    @pieces = []
  end

  def piece_at(location)
    pieces.find { |piece| piece.location == location }
  end

  def select_color(color)
    pieces.select { |piece| piece.color == color }
  end

  def take_piece(location)
    index = pieces.index{ |piece| piece.location == location }
    if index
      pieces.delete_at index
      puts "taking piece"
    end
  end

  def << (pieces_to_add)
    if pieces_to_add.class == Array
      pieces[pieces.length, pieces_to_add.length] = pieces_to_add
    else
      pieces << pieces_to_add
    end
  end
end
