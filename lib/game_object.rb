class GameObject
  include Rect
  
  DebugColor = Gosu::Color::BLUE
  
  attr_reader :x, :y, :width, :height
  
  def initialize(x, y)
    @x, @y = x, y
    @width, @height = Tile::Size, Tile::Size
    @opacity = 1.0
  end
  
  def invincible!(ms)
    @invincible_until = Gosu::milliseconds + ms
  end
  
  def invincible?
    @invincible_until && @invincible_until >= Gosu::milliseconds
  end
  
  def update
  end
  
  def draw
    $window.debug_font.draw self.object_id, @x + 5, @y + 5, Z::HUD
    $window.draw_quad @x, @y, DebugColor,
                      @x + @width, @y, DebugColor,
                      @x, @y + @height, DebugColor,
                      @x + @width, @y + @height, DebugColor
  end
  
end