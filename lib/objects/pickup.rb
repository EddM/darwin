class Pickup < GameObject
  
  def initialize(x, y)
    super(x, y)
    @width, @height = 32, 32
    @rot = 0
  end
  
  def update
    @rot += 1
  end
  
end