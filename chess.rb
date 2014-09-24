require 'rubygems'
require 'gosu'
require_relative 'board'

class Chess < Gosu::Window



  def initialize
    super(720, 720, false)
    self.caption = "Chess"
    @board = Board.new
    create_images
    @piece_selected = nil
    @cursor = Gosu::Image.new(self, 'assets/mouse.png')
  end

  def button_down(id)
    if id == Gosu::MsLeft
      case
      when @piece_selected
        @board.take_piece(location_of_mouse)
        @piece_selected.place_at(location_of_mouse)
        @piece_selected = nil
      else
        @piece_selected = @board.piece_at(location_of_mouse)
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
    when @piece_selected
      piece_image_locations = %w(bb bk bn bp bq br wb wk wn wp wq wr)
      @piece_images[piece_image_locations.index(@piece_selected.file_loc)].draw(self.mouse_x - 45, mouse_y - 45, 0)
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
      unless @piece_selected == piece
        @piece_images[piece_image_locations.index(piece.file_loc)].draw(x, y, 0)
      end
    end
  end

  def create_images
    piece_image_locations = %w(bb bk bn bp bq br wb wk wn wp wq wr)
    @board_image = Gosu::Image.new(self, "assets/board.png", true)
    @piece_images = piece_image_locations.collect { |path| Gosu::Image.new(self, "assets/#{path}.png", true)}
  end

  def location_of_mouse
    row = 8 - (self.mouse_y / 90).to_i
    col = ((self.mouse_x / 90).to_i + 65).chr
    "#{col}#{row}"
  end

end

window = Chess.new
window.show
