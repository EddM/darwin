class Healthpack < Pickup
  
  DebugColor = Gosu::Color::RED
  
  def apply!(player)
    player.heal!
    player.score!(50)
  end
    
end