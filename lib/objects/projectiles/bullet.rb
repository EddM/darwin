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
    
    @width = @height = 20
  end
    
  def draw
    super
  end
  
end