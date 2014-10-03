require 'gosu'

class SelectPromotion < Gosu::Window
  def initialize(color)
    @color = color
    super(360, 90, false)
    create_images
    @background = Gosu::Color::WHITE
  end

  def needs_cursor?
    true
  end

  def create_images
    @piece_images = %w(wb wn wr wq bb bn br bq).collect { |path| Gosu::Image.new(self, "assets/#{path}.png", true) }
  end

  def draw
    draw_background
    draw_pieces
  end

  def draw_background
    draw_quad(0, 0, @background, 0, 90, @background, 360, 0, @background, 360, 90,  @background)
  end

  def draw_pieces
    to_add = {black: 4, white: 0}[@color]
    (0..3).each do |index|
      @piece_images[index + to_add].draw(index * 90, 0 , 0)
    end
  end
end

# SelectPromotion.new(:black).show
