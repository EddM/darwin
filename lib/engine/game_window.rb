class GameWindow < Gosu::Window
  
  attr_reader :state_manager, :debug_font
  
  def initialize(width = 640, height = 480)
    super(width, height, false)
    $window = self
    self.caption = "Darwin's Odyssey"
    
    @state_manager = GameStateManager.new
#    @state_manager << MenuState.new
    @state_manager << PlayingState.new
    @debug_font = Gosu::Font.new(self, Gosu::default_font_name, 12)
  end
  
  def update
    self.caption = "Darwin's Odyssey - #{Gosu::fps} fps - #{Gosu::milliseconds}"
    
    @state_manager.current.update
    exit if button_down?(Gosu::KbEscape)
  end
  
  def draw
    @state_manager.current.draw
  end
  
end