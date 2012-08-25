class Neanderthal < Stage
  
  def initialize(player)
    super(player)
    @range = 25
  end
  
  def apply_attack(enemy)
    enemy.damage!(40)
    enemy.jump_back! unless enemy.dead?
  end
  
end