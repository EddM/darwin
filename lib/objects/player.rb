class Player < GameObject
  
  InvincibleTime  = 3000
  Levels          = %w(Neanderthal EarlyMan Warrior ModernMan Ninja SuperMan)
  
  attr_reader :max_health, :health_remaining, :experience, :level, :score
  
  def initialize(x, y, game_state)
    super(x, y)
    @experience, @kills, @score = 0, 0, 0
    @level, @speed = 0, 1
    @max_health, @health_remaining = 100, 100
    @game_state = game_state
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
    1000 * (@level ** 2)
  end
  
  def level_up!
    @level += 1
  end
  
  def build_stage
    @stage = Kernel.const_get(Levels[@level]).new(self)
  end
  
  def invincible?
    @invincible_until && @invincible_until >= Gosu::milliseconds
  end
  
  def hit!(enemy)
    unless invincible?
      hp!(0 - enemy.damage)
      @invincible_until = Gosu::milliseconds + InvincibleTime
      enemy.damage!(30)
      enemy.jump_back!
    end
  end
  
  def attack
    if $window.button_down?(Gosu::KbSpace)
      @stage.attack!
    end
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
    
    puts "Facing: #{@facing}"
  end
  
  def speed
    @stage.speed
  end
  
  def pickup!(pickup)
    case pickup
    when DNA
      xp!(100)
    end
    
    @game_state.pickups.delete(pickup)
  end
  
  def update
    move
    attack
    check_pickups
    check_enemies
    
    puts "XP: #{@experience}"
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
      self.pickup!(pickup)
    end
  end
    
end