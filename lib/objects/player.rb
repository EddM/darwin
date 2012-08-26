#
# Player handles player game logic, but its @stage handles
# evolution-stage-specific logic and drawing
#
class Player < GameObject
  
  InvincibleTime = 2000
  Levels = %w(Neanderthal EarlyMan Warrior ModernMan Ninja SuperMan)
  
  attr_reader :max_health, :health_remaining, :experience, :level, :score, :sprint, :tired, 
    :evolving, :stage, :game_state, :kills, :facing, :hud
  
  def initialize(x, y, game_state)
    super(x, y)
    @game_state = game_state
    @experience, @kills, @score, @level = 0, 0, 0, 0
    @time, @died_at = Gosu::milliseconds, 0
    @max_health, @health_remaining = 100, 100
    @sprint, @tired = 100, 0
    @facing = :right
    @hud = HUD.new(self)
    
    build_stage
  end
  
  # Number of seconds the user survived for
  def seconds
    ((@died_at - @time) / 1000).to_i
  end
  
  # Give (or take, if passed a negative number) some health
  def hp!(n)
    @health_remaining += n
    if @health_remaining > @max_health
      @health_remaining = @max_health
    elsif @health_remaining <= 0
      die!
      @game_state.die!
    end
  end
  
  # Give user some experience, and level up if needed
  def xp!(n)
    unless @level == (Levels.size - 1)
      @experience += n
      level_up! if @experience >= xp_required
    end
  end
  
  def add_kill!
    @kills += 1
  end
  
  def score!(n)
    @score += n
  end
  
  # Return an array of Enemy objects that are within a given pixel range
  # at the currently facing compass direction
  def enemies_in_range(range)
    return case attacking_direction
    when :right
      @game_state.enemies.select do |e| 
        (e.x > @x && e.x < (self.right + range)) && (e.bottom > @y || e.y < self.bottom)
      end
    when :left
      @game_state.enemies.select do |e| 
        (e.right < @x && e.right > (@x - range)) && (e.bottom > @y || e.y < self.bottom)
      end
    when :up
      @game_state.enemies.select do |e| 
        (e.bottom < @y && e.bottom > (@y - range)) && (e.right > @x && e.x < self.right)
      end
    when :down
      @game_state.enemies.select do |e| 
        (e.y > self.bottom && e.y < (self.bottom + range)) && (e.right > @x && e.x < self.right)
      end
    end
  end
    
  def die!
    @died_at = Gosu::milliseconds
  end
  
  # The amount of experience (dna) required to reach
  # the next level (evolution stage)
  def xp_required
    750 * ((@level + 1) ** 2)
  end
  
  def level_up!
    @level += 1
    build_stage
    @score += 1000
    @game_state.level_up!
    @evolving = 50
    @max_health = @stage.max_health
    heal!
    $window.audio_manager.play! :evolve
  end
  
  def build_stage
    @stage = Kernel.const_get(Levels[@level]).new(self)
  end
  
  # Restore the player's health
  def heal!
    @health_remaining = @max_health
  end
  
  # Tell player that it took damage from a given Enemy
  def hit!(enemy)
    unless invincible?
      $window.audio_manager.play! :hurt
      hp!(0 - enemy.damage)
      invincible!(InvincibleTime)
      enemy.damage!(enemy.damage)
    end
    
    enemy.jump_back!
  end
  
  # Attack if mouse clicked
  def attack
    @stage.attack! if $window.button_down?(Gosu::MsLeft)
  end
  
  def opacity
    invincible? ? 0.6 : 1.0
  end
  
  # Is the user moving, or at least attempting to move?
  def moving?
    $window.button_down?(Gosu::KbS) || $window.button_down?(Gosu::KbD) || $window.button_down?(Gosu::KbW) || $window.button_down?(Gosu::KbA)
  end
  
  # Work out which compass direction the user is trying to attack (pointing their cursor)
  def attacking_direction
    mouse_x, mouse_y = @game_state.camera[0] + $window.mouse_x, @game_state.camera[1] + $window.mouse_y
    
    distance_from_x = (mouse_x - mid_point_x).abs
    distance_from_y = (mouse_y - mid_point_y).abs
    
    if distance_from_x > distance_from_y
      if mouse_x > mid_point_x
        :right
      else mouse_x < mid_point_x
        :left
      end
    else
      if mouse_y > mid_point_y
        :down
      else mouse_y < mid_point_y
        :up
      end
    end
  end
  
  # Would the given coordinate be out of the bounds of the map?
  def out_of_bounds?(x, y)
    x >= (Game::Width - Game::Padding) || x <= (0 + Game::Padding) || y >= (Game::Height - Game::Padding) || y <= (0 + Game::Padding)
  end
  
  # Is the user trying to move? Adjust coordinates appropriately
  def move
    if $window.button_down?(Gosu::KbD)
      @facing = :right
      @x += speed unless out_of_bounds?(@x + speed, @y)
    end
    
    if $window.button_down?(Gosu::KbA)
      @facing = :left
      @x -= speed unless out_of_bounds?(@x - speed, @y)
    end
    
    if $window.button_down?(Gosu::KbW)
      @facing = :up
      @y -= speed unless out_of_bounds?(@x, @y - speed)
    end
    
    if $window.button_down?(Gosu::KbS)
      @facing = :down
      @y += speed unless out_of_bounds?(@x, @y + speed)
    end
    
    sprinting?
  end
  
  # The speed at which the user should move, in pixels per frame.
  # Doubled if sprinting.
  def speed
    if @sprinting
      @stage.speed * 2
    else
      @stage.speed
    end
  end
  
  # Is the user trying to sprint, and does the player have enough
  # energy to sprint?
  def sprinting?
    if $window.button_down?(Gosu::KbLeftShift) && @tired <= 0
      @sprinting = true
    else
      @sprinting = false
      @tired -= 1 unless @tired <= 0
    end
    
    if @sprinting
      @sprint -= 1
      @tired = 300 if @sprint <= 0
    else
      @sprint += 1 unless @sprint >= 100
    end
  end
  
  # Evolution animation countdown
  def evolve
    if @evolving
      @evolving -= 1
      @evolving = nil if @evolving <= 0
    end
  end
  
  def update
    unless @evolving
      move
      attack
      check_pickups
      check_enemies unless $window.cheat_mode
    else
      evolve
    end
    
    @hud.update
    @stage.update
  end
    
  def draw
    @stage.draw
  end
   
  private
  
  # Take damage if clipping any enemy hitboxes
  def check_enemies
    colliding_enemies = @game_state.enemies.select { |enemy| enemy.alive? && enemy.collides?(self) }
    self.hit!(colliding_enemies[0]) if colliding_enemies.any?
  end
  
  # Pick up any items the user is clipping
  def check_pickups
    @game_state.pickups.select { |pickup| pickup.collides?(self) }.each do |pickup|
      pickup.apply!(self)
      @game_state.pickups.delete(pickup)
    end
  end
    
end