class Ninja < Stage
  
  Cooldown = 30
  
  def initialize(player)
    super(player)
    @stars = []
    @cooldown = 0
    @speed = 5
    @max_health = 200
  end
  
  def to_s
    "Ninja"
  end
  
  def attack!
    mid_point = @player.mid_point
    camera = $window.state_manager.current.camera
    fire! Gosu::angle(mid_point[0], mid_point[1], camera[0] + $window.mouse_x, camera[1] + $window.mouse_y)
  end
  
  def update
    @stars.each { |star| star.update }
    @cooldown -= 1 unless @cooldown <= 0
  end
  
  def draw
    super
    @stars.each { |star| star.draw }
  end
  
  def fire!(angle)
    unless @cooldown > 0
      @stars << ThrowingStar.new(@player, angle)
      @cooldown = Cooldown
    end
  end
  
end