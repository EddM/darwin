class IntroState < GameState
  
  def initialize
    @image = Gosu::Image.new($window, "res/story.png", false, 0, 0, 640, 666)
    @skip = Gosu::Image.new($window, "res/skip.png", false, 0, 0, 137, 8)
    @position = $window.height
  end
  
  def update
    @position -= 0.25
    if $window.button_down?(Gosu::KbReturn)
      $window.state_manager.push PlayingState.new
      $window.song.stop
    end
  end
  
  def draw
    @image.draw(0, @position, Z::HUD)
    $window.draw_quad 0, 320, 0x00000000,
                      $window.width, 320, 0x00000000,
                      0, $window.height, 0xff000000,
                      $window.width, $window.height, 0xff000000,
                      Z::HUD
    @skip.draw($window.width - 142, 10, Z::HUD) if @position <= ($window.height - 100)
  end
  
end