class HUD
  
  def initialize(player)
    @player = player
    @score = RenderedText.new("0")
    @heart = Gosu::Image.new($window, "res/heart.png", false, 0, 0, 24, 24)
    @helix = Gosu::Image.new($window, "res/helix.png", false, 0, 0, 24, 24)
  end
  
  def update
    @score.text = @player.score
  end
  
  def draw
    draw_health
    draw_xp
    draw_score
  end
  
  def draw_health
    @heart.draw 25, 25, Z::HUD
    width = (100 * (@player.health_remaining.to_f / @player.max_health.to_f)).to_i
    $window.draw_quad 70, 25, 0xffa20000,
                      70 + width, 25, 0xffa20000,
                      70, 49, 0xffa20000,
                      70 + width, 49, 0xffa20000, Z::HUD
  end
  
  def draw_xp
    @helix.draw 25, 60, Z::HUD
    width = (100 * (@player.experience.to_f / @player.xp_required.to_f)).to_i
    $window.draw_quad 70, 60, 0xff4c4a66,
                      70 + width, 60, 0xff4c4a66,
                      70, 84, 0xff4c4a66,
                      70 + width, 84, 0xff4c4a66, Z::HUD
  end
  
  def draw_score
    $window.translate ($window.width - 25 - @score.width), 10 do
      @score.draw 
    end
  end
  
end