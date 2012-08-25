module Rect
    
  def collides?(rect)
    !(rect.x > right || rect.right < @x || rect.y > bottom || rect.bottom < @y )
  end
  
  def bottom
    @y + @height
  end
  
  def right
    @x + @width
  end
  
  def mid_point
    [mid_point_x, mid_point_y]
  end
  
  def mid_point_x
    @x + (@width / 2)
  end
  
  def mid_point_y
    @y + (@height / 2)
  end
  
end