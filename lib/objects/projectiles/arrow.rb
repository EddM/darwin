class Arrow < Projectile
  
  def initialize(player, angle)
    super(player, angle)
    @speed = 6
    @damage = 50
    @range = 200
  end
  
  def draw
    super
  end
  
end