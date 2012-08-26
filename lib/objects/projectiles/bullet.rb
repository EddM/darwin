class Bullet < Projectile
  
  def initialize(player, angle, state)
    @player, @angle = player, angle
    @game_state = state
    @distance, @origin = 0, [@player.mid_point_x, @player.mid_point_y]
    @x, @y = @origin[0], @origin[1]
    @speed = 25
    @damage = 50
    @range = 500
    $window.audio_manager.play! :shoot2
    @width, @height = 10, 10
  end
    
  def draw
    $window.draw_quad @x, @y, Gosu::Color::BLACK,
                      @x + 10, @y, Gosu::Color::BLACK,
                      @x, @y + 10, Gosu::Color::BLACK,
                      @x + 10, @y + 10, Gosu::Color::BLACK
  end
  
end