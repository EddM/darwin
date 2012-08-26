class HelpState < InexclusiveGameState
  
  def initialize(type)
    @logo = Gosu::Image.new($window, "res/help-#{type.to_s}.png", false, 0, 0, 572, 444)
  end
  
  def update
    $window.state_manager.pop if $window.button_down? Gosu::KbReturn
  end
  
  def draw
    super
    @logo.draw ($window.width / 2) - 286, ($window.height / 2) - 222, Z::HUD
  end
  
end