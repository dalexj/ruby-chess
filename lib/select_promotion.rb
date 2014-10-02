require 'rubygems'
require 'gosu'

class SelectPromotion < Gosu::Window
  def initialize
    super(360, 90, false)
    create_images
  end

  def create_images
    @piece_images = %w(wb wn wr wq bb bn br bq).collect { |path| Gosu::Image.new(self, "assets/#{path}.png", true) }
  end

  def draw
    (0..3).each do |index|
      @piece_images[index].draw(index * 90, 0 , 0)
    end
  end
end
