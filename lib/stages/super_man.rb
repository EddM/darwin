class SuperMan < Stage
  
  def initialize(player)
    super(player)
    @laser = Gosu::Image.new($window, "res/laser.png", false, 0, 0, 640, 16)
    @opacity = 0
    @max_health = 500
    @damage = 500
  end
  
  def to_s
    "Super Man"
  end
  
  def attack!
    mid_point = @player.mid_point
    camera = $window.state_manager.current.camera
    fire! Gosu::angle(mid_point[0], mid_point[1], camera[0] + $window.mouse_x, camera[1] + $window.mouse_y)
    $window.audio_manager.play! :laser
  end
  
  def fire!(angle)
    if @opacity <= 0
      @angle = angle
      @opacity = 1.0
    end
  end
  
  def update
    if @opacity > 0
      @opacity -= 0.1
      @color = Gosu::Color.from_ahsv(255 * @opacity, 0, 0, 1)
    end
    
    if @opacity > 0 && @angle
      target_x = @player.mid_point_x + Gosu::offset_x(@angle, 640)
      target_y = @player.y + 10 + Gosu::offset_y(@angle, 640)
      
      enemies = @player.game_state.enemies.select { |enemy|
        enemy.intersects_line?(@player.mid_point_x, @player.y + 10, target_x, target_y)
      }.each do |enemy|
        enemy.damage!(@damage)
        enemy.hit_by << self
        $window.audio_manager.play! :hit
      end
    end
  end
  
  def draw
    super
    
    if @opacity >= 0 && @angle
      @laser.draw_rot @player.mid_point_x, @player.y + 10, Z::Effects, 270 + @angle, 0, 0.5, 1, 1, @color
    end
  end
  
end