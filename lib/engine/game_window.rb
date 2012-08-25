class GameWindow < Gosu::Window
  
  attr_reader :state_manager
  
  def initialize(width = 640, height = 480)
    super(width, height, false)
    $window = self
    self.caption = "Darwin's Odyssey"
    
    @state_manager = GameStateManager.new
    @state_manager << MenuState.new
  end
  
  def update
    @state_manager.current.update
    exit if button_down?(Gosu::KbEscape)
  end
  
  def draw
    @state_manager.current.draw
  end
  
end