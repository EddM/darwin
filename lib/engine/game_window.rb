# 
# GameWindow is the thing that's shown on the screen.
# The game's event loop starts here.
#
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
    @keycodes = []
  end
  
  # Make sure the cursor appears on screen
  def needs_cursor?
    true
  end
  
  # Stores a short array of the latest keypresses
  # to check for the cheat code. Pass it on to the text input.
  def button_down(id)
    @keycodes << id
    @keycodes = @keycodes[-10..-1] if @keycodes.size > 10
    
#    if id == Gosu::KbTab then
#      index = @text_fields.index(self.text_input) || -1
#      self.text_input = @text_fields[(index + 1) % @text_fields.size]
#    elsif id == Gosu::MsLeft then
#      self.text_input = @text_fields.find { |tf| tf.under_point?(mouse_x, mouse_y) }
#      self.text_input.move_caret(mouse_x) unless self.text_input.nil?
 #   end
  end
  
  # Update the game's state
  def update
    self.caption = "Darwin's Odyssey - #{Gosu::fps} FPS"
    @state_manager.current.update
    exit if button_down?(Gosu::KbEscape)
  end
  
  # Render to screen
  def draw
    @state_manager.current.draw
  end
  
end