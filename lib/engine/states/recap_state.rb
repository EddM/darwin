class RecapState < GameState
  
  def initialize(player)
    @player = player
    @score = 0
    @rendered_text = RenderedText.new("Score #{@score}")
  end
  
  def update
    unless @score == @player.score
      if (@score + 10) > @player.score
        @score += 1
      else
        if @player.score > 2000 && (@player.score - @score) > 1000
          @score += 100
        else
          @score += 10
        end
      end
      
      @rendered_text.text = "Score #{@score.to_s}"
    end
    
    if $window.button_down?(Gosu::KbReturn)
      if @score == @player.score
        $window.state_manager.pop($window.state_manager.stack.size - 1)
      else
        @score = @player.score
      end
    end
  end
  
  def draw
    $window.draw_quad 0, 0, Gosu::Color::BLACK,
                      $window.width, 0, Gosu::Color::BLACK,
                      0, $window.height, 0xff222222,
                      $window.width, $window.height, 0xff222222,
                      Z::Background

    $window.translate 50, 50 do
      @rendered_text.draw
    end
  end
  
end