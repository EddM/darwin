class Arrow < Projectile
  
  def initialize(player, angle, state)
    super(player, angle, state)
    @speed = 6
    @damage = 50
    @range = 200
  end
  
  def draw
    super
  end
  
end