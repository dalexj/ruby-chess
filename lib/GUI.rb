require 'gosu'
require 'pusher-client'
require 'pusher'
require 'json'
require_relative 'game'

class GUI < Gosu::Window
  attr_reader :game
  def initialize
    super(720, 720, false)
    self.caption = "Alex's Swaggin' Chess"
    @game = Game.new
    @background = 0xffdb9370 # some brownish color
    create_images
    create_socket
  end

  def create_socket
    Pusher.url = "http://aa791892d8f69fa95e4e:fd0081e3a9aefc67456a@api.pusherapp.com/apps/92791"

    socket = PusherClient::Socket.new('aa791892d8f69fa95e4e', {secret: "fd0081e3a9aefc67456a"})
    socket.connect(true)
    socket.subscribe("chess_channel1")
    socket["chess_channel1"].bind("move") do |data|
      parsed_data = JSON.parse(data)
      game.move(parsed_data["from"], parsed_data["to"])
    end
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
    Pusher["chess_channel1"].trigger("move", { from: @selected_piece.location, to: location_of_mouse  })
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
    @board_image.draw(0, 0, 0)
    draw_pieces
    draw_possible_moves
    draw_selected_piece
    draw_promotion_pieces(game.turn.to_s.split("_")[0].to_sym) if game.waiting_for_promotion?
  end

  def draw_background
    draw_quad(0, 0, @background, 0, 720, @background, 810, 0, @background, 810, 720,  @background)
  end

  def rectangle(x, y, width, height)
    draw_quad(x, y, @background, x, height + y, @background, width + x, y, @background, width + x, height + y,  @background)
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

  def location_of_mouse(start_x = 0, start_y = 0) # get chess-location ("A1") for the x and y of the mouse
    x = 8 - ((self.mouse_y - start_x) / 90).to_i
    y = ((self.mouse_x - start_y) / 90).to_i + 65
    "#{y.chr}#{x}"
  end

  def find_piece_image(file_loc)
    @piece_images[piece_image_locations.index(file_loc)]
  end

  def piece_image_locations
    %w(bb bk bn bp bq br wb wk wn wp wq wr)
  end

  def select_promotion_piece
    loc = location_of_mouse(*promotion_pieces_start_location)
    return unless loc[1] == "8"
    pieces = [Queen, Rook, Bishop, Knight]
    type = pieces[loc[0].ord - 65]
    game.promote_pawn(type) if type
  end

  def draw_promotion_pieces(color)
    y, x = promotion_pieces_start_location
    rectangle(x, y, 360, 90)
    pieces = %w(q r b n).collect { |loc| "#{color[0]}#{loc}"}

    pieces.each_with_index do |file_loc, index|
      highlight = mouse_over_piece?(index) ? 0xff999999 : 0xffffffff
      find_piece_image(file_loc).draw((index * 90) + x, y, 0, 1, 1, highlight)
    end
  end

  def mouse_over_piece?(index)
    location = location_of_mouse(*promotion_pieces_start_location)
    location[1] == "8" && %w(A B C D)[index] == location[0]
  end

  def promotion_pieces_start_location
    start = Piece.location_to_array_indexes(game.checker.last_move[1]).collect { |index| index * 90 + 45 }

    until start[1] < 360
      start[1] = start[1] - 90
    end

    until start[0] < 630
      start[0] = start[0] - 90
    end
    start
  end
end
