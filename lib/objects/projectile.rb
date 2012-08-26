class Projectile < GameObject
  
  def initialize(player, angle, state)
    @player, @angle = player, angle
    @game_state = state
    @distance, @origin = 0, [@player.mid_point_x, @player.mid_point_y]
    @x, @y = @origin[0], @origin[1]
    $window.audio_manager.play! :shoot1
    
    @width = @height = 20
  end
  
  def update
    @x += Gosu::offset_x @angle, @speed
    @y += Gosu::offset_y @angle, @speed
    
    if Gosu::distance(@origin[0], @origin[1], @x, @y) >= @range
      die!
    else
      check_collision
    end
  end
  
  def check_collision
    colliding_enemies = @game_state.enemies.select { |enemy| enemy.collides?(self) && !enemy.hit_by.index(self) }
    if colliding_enemies.any?
      enemy = colliding_enemies.first
      enemy.damage!(@damage)
      enemy.hit_by << self
      enemy.jump_back! unless enemy.dead?
      die!
      $window.audio_manager.play! :hit
    end
  end
  
  def draw
    $window.draw_quad @x, @y, DebugColor,
                      @x + @width, @y, DebugColor,
                      @x, @y + @height, DebugColor,
                      @x + @width, @y + @height, DebugColor
  end
  
  private
  
  def die!
    @player.stage.reload if @player.stage.respond_to?(:reload)
  end
  
end