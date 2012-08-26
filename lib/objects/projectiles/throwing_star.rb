class ThrowingStar < Projectile
  
  def initialize(player, angle, state)
    super(player, angle, state)
    @speed = 25
    @damage = 50
    @range = 500
  end
  
  def draw
    super
  end
  
end