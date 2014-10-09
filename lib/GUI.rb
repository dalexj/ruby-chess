require 'gosu'
require_relative 'game'

class GUI < Gosu::Window
  attr_reader :game
  def initialize
    super(810, 720, false)
    self.caption = "Alex's Swaggin' Chess"
    @game = Game.new
    @background = Gosu::Color::GRAY
    create_images
  end

  def button_down(id)
    return unless id == Gosu::MsLeft
    if game.waiting_for_promotion?
      select_promotion_piece
    elsif @selected_piece
      make_move
    else
      pick_up_piece
    end
  end

  def make_move
    game.move(@selected_piece.location, location_of_mouse)
    @selected_piece = nil
  end

  def pick_up_piece
    @selected_piece = game.get_piece(location_of_mouse)
    @selected_piece = nil if @selected_piece.instance_of? NullPiece
    @moves = game.get_legal_moves(@selected_piece) if @selected_piece
  end

  def update
    # loser = [:black, :white].select { |color| game.in_checkmate?(color) }
    # puts "#{loser} lost" unless loser.empty?
  end

  def draw
    draw_background
    @board_image.draw(0, 0, 0)
    draw_pieces
    draw_possible_moves
    draw_selected_piece
    draw_promotion_pieces(game.turn.to_s.split("_")[0].to_sym) if game.waiting_for_promotion?
  end

  def draw_promotion_pieces(color)
    add_to = {white: 4, black: 0}[color]
    pieces = %w(q r b n).collect { |loc| "#{color[0]}#{loc}"}
    pieces.reverse! if color == :white

    pieces.each_with_index do |file_loc, index|
      find_piece_image(file_loc).draw(720, (index + add_to) * 90, 0)
    end
  end

  def draw_background
    draw_quad(0, 0, @background, 0, 720, @background, 810, 0, @background, 810, 720,  @background)
  end

  def needs_cursor?
    @selected_piece.nil?
  end

  def draw_selected_piece
    if @selected_piece
      find_piece_image(@selected_piece.file_loc).draw(self.mouse_x - 45, mouse_y - 45, 0)
    end
  end

  def draw_possible_moves
    return unless @selected_piece
    @moves.each do |move|
      y, x = Piece.location_to_array_indexes(move).collect { |index| index * 90 }
      if game.board.piece_at(move)
        transparency = 0x88ffffff # TODO: FIGURE OUT TURNING BLACK TO RED
      else
        transparency = 0x33ffffff
      end
      find_piece_image(@selected_piece.file_loc).draw(x, y, 0, 1, 1, transparency)
    end
  end

  def draw_pieces(pieces = game.board.pieces.reject { |piece| piece == @selected_piece} )
    pieces.each do |piece|
      y, x = piece.to_array_indexes.collect { |index| index * 90 }
      unless @selected_piece && @moves.include?(piece.location)
        find_piece_image(piece.file_loc).draw(x, y, 0)
      else
        find_piece_image(piece.file_loc).draw(x, y, 0, 1, 1, 0x33ffffff)
      end
    end
  end

  def create_images
    @board_image = Gosu::Image.new(self, "assets/board.png", true)
    @piece_images = piece_image_locations.collect { |path| Gosu::Image.new(self, "assets/#{path}.png", true) }
  end

  def location_of_mouse # get chess-location ("A1") for the x and y of the mouse
    row = 8 - (self.mouse_y / 90).to_i
    col = ((self.mouse_x / 90).to_i + 65).chr
    "#{col}#{row}"
  end

  def find_piece_image(file_loc)
    @piece_images[piece_image_locations.index(file_loc)]
  end

  def piece_image_locations
    %w(bb bk bn bp bq br wb wk wn wp wq wr)
  end

  def select_promotion_piece
    return unless location_of_mouse[0] == "I" # grey strip to the right of board
    pieces = [Queen, Rook, Bishop, Knight]
    if game.turn.to_s.split("_")[0].to_sym == :white
      add_to = -1
    else
      add_to = -5
      pieces.reverse!
    end
    type = pieces[location_of_mouse[1].to_i + add_to]
    game.promote_pawn(type) if type
  end
end
