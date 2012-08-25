class Stage
  
  DebugColor = Gosu::Color::WHITE
  
  attr_reader :speed, :max_health
  
  def initialize(player)
    @player = player
    @speed = 3
    @max_health = 100
  end
  
  def attack!
    raise "Didn't implement #attack!"
  end
  
  def update
  end
  
  def draw
    $window.debug_font.draw self.object_id, @player.x + 5, @player.y + 5, Z::HUD, 1, 1, Gosu::Color::RED
    $window.draw_quad @player.x, @player.y, DebugColor,
                      @player.x + @player.width, @player.y, DebugColor,
                      @player.x, @player.y + @player.height, DebugColor,
                      @player.x + @player.width, @player.y + @player.height, DebugColor, Z::Player
  end
  
end