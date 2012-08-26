class GameState
  
  def exclusive?
    true
  end
  
  def update
    raise "#update not implemented"
  end
  
  def draw
    $window.state_manager.previous.draw unless exclusive?
  end
    
end