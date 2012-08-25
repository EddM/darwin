module Rect
    
  def collides?(rect)
    !(rect.x > right || rect.right < @x || rect.y > bottom || rect.bottom < @y )
  end
  
  def intersects_line?(x1, y1, x2, y2)
    t0 = 0.0
    t1 = 1.0
    p = q = r = 0.0

    x_delta = x2 - x1
    y_delta = y2 - y1

    (0..3).each do |edge|

      if edge == 0 # left edge
        p = -x_delta
        q = -(@x - x1)
      end

      if edge == 1 # right edge
        p = x_delta
        q = (self.right - x1)
      end

      if edge == 2 # top edge
        p = -(y_delta)
        q = -(@y - y1)
      end

      if edge == 3 # bottom edge
        p = y_delta
        q = (self.bottom - y1)
      end

      r = q.to_f / p.to_f

      return false if p == 0 && q < 0 

      if p < 0
        if r > t1
          return false
        elsif r > t0
          t0 = r
        end
      elsif p > 0
        if r < t0
          return false
        elsif r < t1
          t1 = r
        end
      end
    end

    true
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