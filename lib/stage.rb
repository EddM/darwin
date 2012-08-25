class Stage
  
  DebugColor = Gosu::Color::WHITE
  
  attr_reader :speed
  
  def initialize(player)
    @player = player
    @has_projectile = false
    @range = 0
    @speed = 2
  end
  
  def attack!
    unless @has_projectile
      enemies = @player.enemies_in_range(@range)
      puts enemies
      apply_attack(enemies.first) if enemies.any?
    else
      
    end
  end
  
  def apply_attack
    raise "Didn't implement #apply_attack"
  end
  
  def update
  end
  
  def draw
    $window.debug_font.draw self.object_id, @player.x + 5, @player.y + 5, Z::HUD, 1, 1, Gosu::Color::RED
    $window.draw_quad @player.x, @player.y, DebugColor,
                      @player.x + @player.width, @player.y, DebugColor,
                      @player.x, @player.y + @player.height, DebugColor,
                      @player.x + @player.width, @player.y + @player.height, DebugColor
  end
  
end