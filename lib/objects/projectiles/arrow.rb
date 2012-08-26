class Arrow < Projectile
  
  def initialize(player, angle, state, image)
    super(player, angle, state)
    @speed = 6
    @damage = 50
    @range = 200
    @image = image
  end
  
  def draw
    @image.draw_rot @x, @y, Z::Items, @angle - 45
  end
  
end