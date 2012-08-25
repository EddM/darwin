class MenuState < GameState
  
  def initialize
    @buttons = []
    @buttons << Button.new(($window.width / 2) - 118, 300, :new_game, Proc.new {
      $window.state_manager.push PlayingState.new
    })
    
    @buttons << Button.new(($window.width / 2) - 118, 350, :high_scores, Proc.new {
      $window.state_manager.push HighScoresState.new
    })
    
    @earth = Gosu::Image.new($window, "res/earth.png", false, 0, 0, 640, 640)
    @position = 150
    @opacity = 0
  end
  
  def update
    @opacity += 0.001  unless @opacity >= 1.0
    @position -= 0.5    unless @position <= 0
    @buttons.each { |btn| btn.update }
  end
  
  def draw
    @color = Gosu::Color.from_ahsv(255 * @opacity, 0, 0, 1)
    @earth.draw(0, 100 + @position, Z::UI, 1.0, 1.0, @color)
    @buttons.each { |btn| btn.draw }
  end
  
end