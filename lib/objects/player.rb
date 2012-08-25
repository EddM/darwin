class Player < GameObject
  
  InvincibleTime = 2000
  Levels = %w(Neanderthal EarlyMan Warrior ModernMan Ninja SuperMan)
  
  attr_reader :max_health, :health_remaining, :experience, :level, :score, :sprint, :tired, :evolving, :stage
  
  def initialize(x, y, game_state)
    super(x, y)
    @game_state = game_state
    @experience, @kills, @score, @level = 0, 0, 0, 0
    @max_health, @health_remaining = 100, 100
    @sprint, @tired = 100, 0
    @facing = :right
    
    build_stage
  end
  
  def hp!(n)
    @health_remaining += n
  end
  
  def xp!(n)
    @experience += n
    level_up! if @experience >= xp_required
  end
  
  def score!(n)
    @score += n
  end
    
  def enemies_in_range(range)
    return case @facing
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
    
  def xp_required
    1000 * ((@level + 1) ** 2)
  end
  
  def level_up!
    @level += 1
    @score += 1000
    @game_state.level_up!
    @evolving = 50
  end
  
  def build_stage
    @stage = Kernel.const_get(Levels[@level]).new(self)
  end
  
  def heal!
    @health_remaining = @max_health
  end
  
  def hit!(enemy)
    unless invincible?
      hp!(0 - enemy.damage)
      invincible!(InvincibleTime)
      enemy.damage!(enemy.damage)
    end
    
    enemy.jump_back!
  end
  
  def attack
    @stage.attack! if $window.button_down?(Gosu::MsLeft)
  end
  
  def move
    if $window.button_down?(Gosu::KbD)
      @facing = :right
      @x += speed 
    end
    
    if $window.button_down?(Gosu::KbA)
      @facing = :left
      @x -= speed
    end
    
    if $window.button_down?(Gosu::KbW)
      @facing = :up
      @y -= speed
    end
    
    if $window.button_down?(Gosu::KbS)
      @facing = :down
      @y += speed
    end
    
    sprinting?
  end
  
  def speed
    if @sprinting
      @stage.speed * 2
    else
      @stage.speed
    end
  end
  
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
  
  def evolve
    if @evolving
      @evolving -= 1
      if @evolving <= 0
        @evolving = nil
        build_stage
      end
    end
  end
  
  def update
    unless @evolving
      move
      attack
      check_pickups
      check_enemies
    else
      evolve
    end
    
    @stage.update
  end
    
  def draw
    @stage.draw
  end
   
  private
  
  def check_enemies
    colliding_enemies = @game_state.enemies.select { |enemy| enemy.collides?(self) }
    self.hit!(colliding_enemies[0]) if colliding_enemies.any?
  end
  
  def check_pickups
    @game_state.pickups.select { |pickup| pickup.collides?(self) }.each do |pickup|
      pickup.apply!(self)
      @game_state.pickups.delete(pickup)
    end
  end
    
end