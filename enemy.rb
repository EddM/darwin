class Enemy
  
  attr_reader :speed
  
  def initialize(x, y, speed)
    @x, @y = x, y
    @speed = speed
  end
  
end