class RecapState < GameState
  
  def initialize(player)
    @player = player
    @score = 0
    @font = Gosu::Font.new($window, Gosu.default_font_name, 14)
    @kills_text = RenderedText.new("Kills     #{@player.kills}")
    @time_text =  RenderedText.new("Survived  #{@player.seconds} seconds")
    @score_text = RenderedText.new("Score     #{@score}")
    @continue = Button.new(($window.width / 2) - 118, 400, :continue, Proc.new {
      $window.state_manager.clear MenuState.new
      $window.text_input = nil
    })
    
    @submit = Button.new(($window.width / 2) - 118, 320, :submit_score, Proc.new { submit_score })
    @input = TextInput.new(($window.width / 2) - 118, 250, @font)
    $window.text_input = @input
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
      
      if $window.button_down?(Gosu::MsLeft)
        $window.text_input = @input if @input.intersects_point?($window.mouse_x, $window.mouse_y)
      end
    end
    
    if $window.button_down?(Gosu::KbReturn)
      @score = @player.score 
      @score_text.text = "Score     #{@score.to_s}"
    end
    
    @submit.update
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
    
    @input.draw
    @submit.draw
    @continue.draw
    
    @font.draw "Thanks for submitting your score", ($window.width / 2) - (@font.text_width("Thanks for submitting your score") / 2), 360, 999 if @show_success
    @font.draw "Sorry, an error occured while sending score", ($window.width / 2) - 118, 360, 999 if @show_error
  end
  
  private
  
  def name_input_value
    $window.text_input.text
  end
  
  # Yes, I know you can forge these http requests. Aren't you clever. You have the damn source code.
  # Please don't though. For the fun of the competition.
  def submit_score
    unless @sending
      begin
        @sending = true
    
        response = Net::HTTP.start('scores.eddmorgan.com', 80) do |http|
          http.post '/scores', "name=#{name_input_value}&score=#{@player.score}"
        end
      
        handle_response(response)
      rescue
        handle_error
      end
    end
  end
  
  def handle_response(response)
    if response.code == "200"
      @show_success = true
    else
      handle_error
    end
  end
  
  def handle_error
    @show_error = true
  end
  
end