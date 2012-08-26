class PlayingState < GameState
  
  attr_reader :enemies, :pickups, :camera
  
  def initialize
    @player = Player.new($window.width / 2, $window.height / 2, self)
    @ground_tile = Gosu::Image.new($window, "res/ground.png", true, 0, 0, 64, 64)
    @enemies, @pickups = [], []
    @spawn_frequency = 4000 # 4 sec.
    @last_spawn = 0
    move_camera
    place_pickups
  end
  
  def update
    unless @seen_dialog
      $window.state_manager.push DialogState.new("Level #{@player.level + 1}", @player.stage.to_s)
      @seen_dialog = true
    else
      $window.state_manager.push(HelpState.new(@player.stage.class.to_s.downcase.to_sym)) if $window.button_down? Gosu::KbH
      
      if (Gosu::milliseconds - @last_spawn) >= @spawn_frequency
        @last_spawn = Gosu::milliseconds
        spawn_zombie!
      end
    
      @player.update
      @enemies.each { |e| e.update } unless @player.evolving
      @pickups.each { |p| p.update } unless @player.evolving
      move_camera
    end
  end
  
  def spawn_zombie!(x = nil, y = nil)
    unless @enemies.size >= Game::MaxEnemies
      x, y = random_coordinates unless x && y
      @enemies << Enemy.new(x, y, self, @player)
    end
  end
  
  def level_up!
    @spawn_frequency -= 750
    $window.state_manager.push DialogState.new("Level #{@player.level + 1}", @player.stage.to_s)
  end
  
  def die!
    $window.state_manager.push DialogState.new("Game Over", "", Proc.new {
      $window.state_manager.pop
      $window.state_manager.push RecapState.new(@player)
    })
  end
  
  def draw
    draw_hud
    draw_debug
    
    $window.translate(-@camera.first, -@camera.last) do
      draw_background
      @player.draw
      @enemies.each { |e| e.draw }
      @pickups.each { |p| p.draw }
    end
  end
  
  private
  
  def place_pickups
    @pickups << Healthpack.new(50, 50)
    @pickups << Healthpack.new(Game::Width - 100, 50)
    @pickups << Healthpack.new(Game::Height - 100, 50)
    @pickups << Healthpack.new(Game::Height - 100, Game::Width - 100)
  end
  
  def random_coordinates
    rand_x = rand(Enemy::SpawnRange) + Enemy::MinSpawnDistance
    rand_y = rand(Enemy::SpawnRange) + Enemy::MinSpawnDistance
    rand_x = rand(2) == 0 ? (@player.right + rand_x) : (@player.x - rand_x)
    rand_y = rand(2) == 0 ? (@player.bottom + rand_y) : (@player.y - rand_y)
    [rand_x, rand_y]
  end
  
  def draw_hud
  end
  
  def draw_debug
    $window.debug_font.draw "Sprint: #{@player.sprint}", 10, 10, Z::HUD
    $window.debug_font.draw "Tired: #{@player.tired}", 10, 30, Z::HUD
    $window.debug_font.draw "XP: #{@player.experience}/#{@player.xp_required}", 10, 50, Z::HUD
    $window.debug_font.draw "HP: #{@player.health_remaining}/#{@player.max_health}", 10, 70, Z::HUD
    $window.debug_font.draw "Score: #{@player.score}", 10, 90, Z::HUD
  end
  
  def draw_background
  end
  
  def move_camera
    cam_x = [[@player.x - ($window.width / 2), 0].max, Game::Width - $window.width].min
    cam_y = [[@player.y - ($window.height / 2), 0].max, Game::Height - $window.height].min
    @camera = [cam_x, cam_y]
  end
  
end