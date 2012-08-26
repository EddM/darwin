class RecapState < GameState
  
  def initialize(player)
    @player = player
    @score = 0
    @kills_text = RenderedText.new("Kills     #{@player.kills}")
    @time_text =  RenderedText.new("Survived  #{@player.seconds} seconds")
    @score_text = RenderedText.new("Score     #{@score}")
    @continue = Button.new(($window.width / 2) - 118, 400, :continue, Proc.new {
      $window.state_manager.clear MenuState.new
    })
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
      
      @score_text.text = "Score     #{@score.to_s}"
    end
    
    if $window.button_down?(Gosu::KbReturn)
      @score = @player.score 
      @score_text.text = "Score     #{@score.to_s}"
    end
    
    @continue.update
  end
  
  def draw
    $window.draw_quad 0, 0, Gosu::Color::BLACK,
                      $window.width, 0, Gosu::Color::BLACK,
                      0, $window.height, 0xff222222,
                      $window.width, $window.height, 0xff222222,
                      Z::Background

    $window.translate 50, 50 do
      $window.translate(0, 0)  { @kills_text.draw }
      $window.translate(0, 25) { @time_text.draw }
      $window.translate(0, 50) { @score_text.draw }
    end
    
    @continue.draw
  end
  
end