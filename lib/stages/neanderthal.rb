class Neanderthal < Stage
  
  def initialize(player)
    super(player)
    @range = 35
  end
  
  def attack!
    enemies = @player.enemies_in_range(@range)
    enemy = enemies[0]
    apply_attack(enemy) if enemy && !enemy.invincible?
  end
  
  def apply_attack(enemy)
    enemy.invincible!(100)
    enemy.damage!(40)
    enemy.jump_back! unless enemy.dead?
  end
  
  def update
  end
  
  def draw
    super
  end
  
end