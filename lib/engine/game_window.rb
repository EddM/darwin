class GameWindow < Gosu::Window
  
  attr_reader :state_manager, :debug_font, :audio_manager
  
  def initialize(width = 640, height = 480)
    super(width, height, false)
    $window = self
    self.caption = "Darwin's Odyssey"
    
    @audio_manager = AudioManager.new
    @state_manager = GameStateManager.new
    @state_manager << MenuState.new
    @debug_font = Gosu::Font.new(self, Gosu::default_font_name, 12)
  end
  
  def needs_cursor?
    true
  end
  
  def update
    self.caption = "Darwin's Odyssey - #{Gosu::fps} FPS"
    @state_manager.current.update
    exit if button_down?(Gosu::KbEscape)
  end
  
  def draw
    @state_manager.current.draw
  end
  
end