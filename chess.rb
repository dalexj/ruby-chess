require 'rubygems'
require 'gosu'
require_relative 'board'

class Chess < Gosu::Window
  def initialize
    super(720, 720, false)
    self.caption = "Chess"
    @board = Board.new
    @cursor = Gosu::Image.new(self, 'assets/mouse.png')
    create_images
  end

  def button_down(id)
    if id == Gosu::MsLeft
      case
      when @selected_piece
        @board.move(@selected_piece.location, location_of_mouse)
        @selected_piece = nil
      else
        @selected_piece = @board.piece_at(location_of_mouse)
      end
    end
  end

  def update
  end

  def draw
    @board_image.draw(0, 0, 0)
    draw_pieces
    draw_cursor
  end

  def draw_cursor
    case
    when @selected_piece
      piece_image_locations = %w(bb bk bn bp bq br wb wk wn wp wq wr)
      @piece_images[piece_image_locations.index(@selected_piece.file_loc)].draw(self.mouse_x - 45, mouse_y - 45, 0)
    else
      @cursor.draw(self.mouse_x, self.mouse_y, 0)
    end
  end

  def draw_pieces(pieces = @board.pieces)
    piece_image_locations = %w(bb bk bn bp bq br wb wk wn wp wq wr)
    pieces.each do |piece|
      y, x = piece.to_array_indexes
      x *= 90
      y *= 90
      unless @selected_piece == piece
        @piece_images[piece_image_locations.index(piece.file_loc)].draw(x, y, 0)
      end
    end
  end

  def create_images
    piece_image_locations = %w(bb bk bn bp bq br wb wk wn wp wq wr)
    @board_image = Gosu::Image.new(self, "assets/board.png", true)
    @piece_images = piece_image_locations.collect { |path| Gosu::Image.new(self, "assets/#{path}.png", true) }
  end

  def location_of_mouse # get chess-location ("A1") for the x and y of the mouse
    row = 8 - (self.mouse_y / 90).to_i
    col = ((self.mouse_x / 90).to_i + 65).chr
    "#{col}#{row}"
  end
end

window = Chess.new
window.show
