class ModernMan < Stage
  
  Cooldown = 25
  
  def initialize(player)
    super(player)
    @bullets = []
    @cooldown = 0
  end
  
  def to_s
    "Modern Man"
  end
  
  def attack!
    mid_point = @player.mid_point
    camera = $window.state_manager.current.camera
    fire! Gosu::angle(mid_point[0], mid_point[1], camera[0] + $window.mouse_x, camera[1] + $window.mouse_y)
  end
  
  def update
    @bullets.each { |bullet| bullet.update }
    @cooldown -= 1 unless @cooldown <= 0
  end
  
  def draw
    super
    @bullets.each { |bullet| bullet.draw }
  end
  
  def fire!(angle)
    unless @cooldown > 0
      @bullets << Bullet.new(@player, angle, $window.state_manager.current)
      @cooldown = Cooldown
    end
  end
  
end