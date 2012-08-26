class DNA < Pickup
  
  DebugColor = Gosu::Color::GREEN
  
  def apply!(player)
    player.xp!(150)
    player.score!(200)
    $window.audio_manager.play! :pickup1
  end
    
end