class ThrowingStar < Projectile
  
  def initialize(player, angle, state, image)
    super(player, angle, state)
    @speed = 25
    @damage = 50
    @range = 500
    @display_angle = 0
    @image = image
  end
  
  def update
    super
    @display_angle += 20
  end
  
  def draw
    @image.draw_rot @x, @y, Z::Items, @display_angle
  end
  
end