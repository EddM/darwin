class PlayingState < GameState
  
  attr_reader :enemies, :pickups, :camera
  
  def initialize
    @player = Player.new(Game::Width / 2, 200, self)
    @background = Gosu::Image.new($window, "res/map.png", true, 0, 0, 6400, 3840)
    @helptext = Gosu::Image.new($window, "res/press_h_for_help.png", true, 0, 0, 187, 8)
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
  
  # Spawn a zombie at given (or random) coordinates
  # unless too many already exist
  def spawn_zombie!(x = nil, y = nil)
    unless @enemies.size >= Game::MaxEnemies
      x, y = random_coordinates unless x && y
      @enemies << Enemy.new(x, y, self, @player)
    end
  end
  
  # Make the difficulty harder for the player
  # and show them the 'new level' dialog
  def level_up!
    @spawn_frequency -= 750
    $window.state_manager.push DialogState.new("Level #{@player.level + 1}", @player.stage.to_s)
  end
  
  # Oh noes, player died
  def die!
    $window.state_manager.push DialogState.new("Game Over", "", Proc.new {
      $window.state_manager.pop
      $window.state_manager.push RecapState.new(@player)
    })
  end
  
  def draw
    draw_hud
    draw_debug if $debug
    
    $window.translate(-@camera.first, -@camera.last) do
      draw_background
      @player.draw
      @enemies.each { |e| e.draw }
      @pickups.each { |p| p.draw }
    end
  end
  
  private
  
  # Place some healthpacks for the player to get
  def place_pickups
    healthpack_offset = 200
    @pickups << Healthpack.new(healthpack_offset, healthpack_offset)
    @pickups << Healthpack.new(Game::Width - healthpack_offset, healthpack_offset)
    @pickups << Healthpack.new(Game::Height - healthpack_offset, healthpack_offset)
    @pickups << Healthpack.new(Game::Height - healthpack_offset, Game::Width - healthpack_offset)
  end
  
  # Generate some X and Y coordinates that are close to the
  # player, but not too close
  def random_coordinates
    rand_x = rand(Enemy::SpawnRange) + Enemy::MinSpawnDistance
    rand_y = rand(Enemy::SpawnRange) + Enemy::MinSpawnDistance
    rand_x = rand(2) == 0 ? (@player.right + rand_x) : (@player.x - rand_x)
    rand_y = rand(2) == 0 ? (@player.bottom + rand_y) : (@player.y - rand_y)
    [rand_x, rand_y]
  end
  
  def draw_hud
    @player.hud.draw
    @helptext.draw 5, ($window.height - 13), Z::HUD
  end
  
  def draw_debug
    $window.debug_font.draw "Sprint: #{@player.sprint}", 10, 10, Z::HUD
    $window.debug_font.draw "Tired: #{@player.tired}", 10, 30, Z::HUD
    $window.debug_font.draw "XP: #{@player.experience}/#{@player.xp_required}", 10, 50, Z::HUD
    $window.debug_font.draw "HP: #{@player.health_remaining}/#{@player.max_health}", 10, 70, Z::HUD
    $window.debug_font.draw "Score: #{@player.score}", 10, 90, Z::HUD
  end
  
  def draw_background
    @background.draw 0, 0, Z::Background
  end
  
  # Center the 'camera' on the user, or off-center if
  # we risk displaying non-game space
  def move_camera
    cam_x = [[@player.x - ($window.width / 2), 0].max, Game::Width - $window.width].min
    cam_y = [[@player.y - ($window.height / 2), 0].max, Game::Height - $window.height].min
    @camera = [cam_x, cam_y]
  end
  
end