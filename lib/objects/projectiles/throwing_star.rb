class ThrowingStar < Projectile
  
  def initialize(player, angle)
    super(player, angle)
    @speed = 25
    @damage = 50
    @range = 500
  end
  
  def draw
    super
  end
  
end