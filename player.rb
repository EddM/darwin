class Player
  
  attr_reader :max_health, :health_remaining, :experience, :level, :score
  
  def initialize
    @experience, @kills, @score = 0, 0, 0
    @level, @speed = 1, 1
    @max_health, @health_remaining = 100, 100
  end
  
  def xp!(n)
    @experience += n
    level_up! if @experience >= xp_required
  end
    
  def xp_required
    1000 * (@level ** 2)
  end
  
end