class Pickup < GameObject
  
  def initialize(x, y)
    super(x, y)
    @width, @height = 32, 32
    @rot = 0
    @image = Gosu::Image.new($window, "res/#{self.class.to_s.downcase}.png")
  end
  
  def update
    @rot += 1
  end
  
  def draw
    $window.rotate @rot, self.mid_point_x, self.mid_point_y do
      @image.draw @x, @y, Z::Items
    end
  end
  
  def apply!(player)
    raise "Didn't implement #apply!"
  end
  
end