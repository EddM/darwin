class PlayingState < GameState
  
  attr_reader :enemies, :pickups
  
  def initialize
    @player = Player.new(0, 0, self)
    @ground_tile = Gosu::Image.new($window, "res/ground.png", true, 0, 0, 64, 64)
    @enemies, @pickups = [], []
    @spawn_frequency = 1000
    @last_spawn = 0
    
    @pickups << DNA.new(200, 200)
  end
  
  def update
    if (Gosu::milliseconds - @last_spawn) >= @spawn_frequency
      @last_spawn = Gosu::milliseconds
      spawn_zombie!(100, 100) if rand(2) == 0
    end
    
    @player.update
    @enemies.each { |e| e.update }
    @pickups.each { |p| p.update }
    move_camera
  end
  
  def spawn_zombie!(x = nil, y = nil)
    unless @enemies.size >= Game::MaxEnemies
      x, y = random_coordinates unless x && y
      @enemies << Enemy.new(x, y, @player)
    end
  end
  
  def draw
    draw_background
    draw_hud
    
    $window.translate(-@camera.first, -@camera.last) do
      @player.draw
      @enemies.each { |e| e.draw }
      @pickups.each { |p| p.draw }
    end
  end
  
  private
  
  def random_coordinates
    # at least 100 pixels away, no more than 400 pixels
    [rand(300) + 100, rand(300) + 100]
  end
  
  def draw_hud
  end
  
  def draw_background
  end
  
  def move_camera
    cam_x = [[@player.x - ($window.width / 2), 0].max, Game::Width - $window.width].min
    cam_y = [[@player.y - ($window.height / 2), 0].max, Game::Height - $window.height].min
    @camera = [cam_x, cam_y]
  end
  
end