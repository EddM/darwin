class EarlyMan < Stage
  
  def initialize(player)
    super(player)
  end
  
  def to_s
    "Early Man"
  end
  
  def attack!
    mid_point = @player.mid_point
    camera = $window.state_manager.current.camera
    fire! Gosu::angle(mid_point[0], mid_point[1], camera[0] + $window.mouse_x, camera[1] + $window.mouse_y)
  end
  
  def update
    @arrow.update if @arrow
  end
  
  def draw
    super
    @arrow.draw if @arrow
  end
  
  def fire!(angle)
    unless @arrow
      @arrow = Arrow.new(@player, angle)
    end
  end
  
  def reload
    @arrow = nil
  end
  
end