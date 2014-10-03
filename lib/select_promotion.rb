require 'gosu'

class SelectPromotion < Gosu::Window
  def initialize
    super(360, 90, false)
    create_images
    @background = Gosu::Color::WHITE
  end

  def create_images
    @piece_images = %w(wb wn wr wq bb bn br bq).collect { |path| Gosu::Image.new(self, "assets/#{path}.png", true) }
    @cursor = Gosu::Image.new(self, 'assets/mouse.png')
  end

  def draw
    draw_background
    draw_pieces
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end

  def draw_background
    draw_quad(0, 0, @background, 0, 90, @background, 360, 0, @background, 360, 90,  @background)
  end

  def draw_pieces
    to_add = 4
    (0..3).each do |index|
      @piece_images[index + to_add].draw(index * 90, 0 , 0)
    end
  end
end

# SelectPromotion.new.show
