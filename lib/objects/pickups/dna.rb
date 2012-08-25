class DNA < Pickup
  
  DebugColor = Gosu::Color::GREEN
  
  def apply!(player)
    player.xp!(100)
    player.score!(200)
  end
    
end