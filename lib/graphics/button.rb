class Button
  include Rect
  
  def initialize(x, y, image, callback = nil)
    @x, @y = x, y
    @image = Gosu::Image.new($window, "res/#{image.to_s}.png", false, 0, 0, 236, 32)
    @hover = Gosu::Image.new($window, "res/#{image.to_s}_over.png", false, 0, 0, 236, 32)
    @width, @height = @image.width, @image.height
    @callback = callback
  end
  
  def width
    @image.width
  end
  
  def height
    @image.height
  end
  
  def hovering?
    intersects_point?($window.mouse_x, $window.mouse_y)
  end
  
  def update
    if $window.button_down?(Gosu::MsLeft) && hovering? && @callback
      @callback.call
    end
  end
  
  def draw
    if @hover && hovering?
      @hover.draw @x, @y, Z::UI
    else
      @image.draw @x, @y, Z::UI
    end
  end
  
end