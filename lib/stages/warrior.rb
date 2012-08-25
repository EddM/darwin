class Warrior < Stage
    
  def initialize(player)
    super(player)
    @range = 50
  end
  
  def attack!
    enemies = @player.enemies_in_range(@range)
    apply_attack(enemies.first) if enemies.any?
  end
  
  def apply_attack(enemy)
    enemy.damage!(70)
    enemy.jump_back! unless enemy.dead?
  end
  
  def update
  end
  
  def draw
    super
  end
  
end