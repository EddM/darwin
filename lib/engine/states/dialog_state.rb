class DialogState < GameState
  
  def initialize(header, text, callback = nil)
    @header, @text, @callback = header, text, callback
    @opacity, @text_opacity = 0.0, 0.0
    @height = 100
    
    @lines = [RenderedText.new(header), RenderedText.new(text)]
  end
  
  def update
    unless @opacity >= 0.8
      @opacity += 0.02
    else
      unless @text_opacity >= 1.0
        @text_opacity += 0.02
      end
    end
    
    if $window.button_down?(Gosu::KbReturn)
      if @callback
        @callback.call
      else
        $window.state_manager.pop
      end
    end
  end
  
  def draw
    color = Gosu::Color.from_ahsv((255 * @opacity).to_i, 0, 0, 0)
    
    $window.translate 0, 100 do
      $window.draw_quad 0, 0, color,
                        $window.width, 0, color,
                        0 + @height, 0, color,
                        0 + @height, $window.width, color, Z::UI
      $window.translate(30, 30) { @lines[0].draw(@text_opacity) }
      $window.translate(30, 55) { @lines[1].draw(@text_opacity) }
    end
    $window.state_manager.previous.draw
  end
  
end