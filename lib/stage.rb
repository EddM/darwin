#
# Evolutionary stage
#
class Stage
  
  DebugColor = Gosu::Color::WHITE
  FacingIndices = { :right => 0, :left => 3, :down => 6, :up => 9 }
  
  attr_reader :speed, :max_health
  
  def initialize(player)
    @player = player
    @speed = 3
    @max_health = 100
    
    @spritesheet = Gosu::Image.load_tiles($window, "res/sprites/#{self.class.to_s.downcase}.png", 64, 64, true)
  end
  
  def facing_index
    FacingIndices[@player.facing]
  end
  
  def attack!
    raise "Didn't implement #attack!"
  end
  
  def frame
    if @player.moving?
      Gosu::milliseconds.to_s[-2..-1].to_i >= 50 ? 1 : 2
    else
      0
    end
  end
  
  def draw   
    @color = Gosu::Color.from_ahsv(255 * @player.opacity, 0, 0, 1)
    @spritesheet[facing_index + frame].draw @player.x, @player.y, Z::Player, 1, 1, @color
  end
  
end