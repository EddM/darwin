class DNA < Pickup
  
  DebugColor = Gosu::Color::GREEN
  
  def apply!(player)
    player.xp!(100)
    player.score!(200)
  end
  
  def draw
    $window.rotate @rot, self.mid_point_x, self.mid_point_y do
      $window.debug_font.draw self.object_id, @x + 5, @y + 5, Z::HUD
      $window.draw_quad @x, @y, DebugColor,
                        @x + @width, @y, DebugColor,
                        @x, @y + @height, DebugColor,
                        @x + @width, @y + @height, DebugColor
    end
  end
  
end