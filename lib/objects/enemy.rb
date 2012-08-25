class Enemy < GameObject

  MinSpawnDistance = 100
  SpawnRange = 250
  JumpBackDistance = 150
  Speed = 1
  
  attr_reader :speed, :damage, :hit_by
  
  def initialize(x, y, game_state, player, speed = 1)
    super(x, y)
    @player = player
    @damage = 250
    @hp = 50 + (rand(6) * 10)
    @game_state = game_state
    @hit_by = []
  end
  
  def dead?
    @hp <= 0
  end
  
  def alive?
    !dead?
  end
  
  def damage!(n)
    @hp -= n
  end
  
  def move
    move_x
    move_y
    
    if @jumping_back && @jumping_back > 0
      if @facing_x == :left
        @x += 10
      elsif @facing_x == :right
        @x -= 10
      end
      
      if @facing_y == :top
        @y += 10
      elsif @facing_y == :bottom
        @y -= 10
      end
      
      @jumping_back -= 10
    end
  end
  
  def move_x
    if @player.x < @x
      @facing_x = :left
      @x -= Speed
    elsif @player.x > @x
      @facing_x = :right
      @x += Speed
    end
  end
  
  def move_y
    if @player.y < @y
      @facing_y = :top
      @y -= Speed
    elsif @player.y > @y
      @facing_y = :bottom
      @y += Speed
    end
  end
  
  def jump_back!
    @jumping_back = JumpBackDistance
  end
  
  def braaaaains
    if rand(250) == 0
      $window.audio_manager.play_at_distance! :"brains#{rand(2) + 1}", [@player.x, @player.y], [@x, @y], 500
    end
  end
  
  def draw
    super
    $window.debug_font.draw "#{@hp} HP", @x + 5, @y + 15, Z::HUD
  end
  
  def update
    if alive?
      move
      braaaaains
    else
      if @opacity <= 0
        @player.score!(500)
        @game_state.pickups << DNA.new(@x, @y)
        @game_state.enemies.delete(self)
      else
        @opacity -= 0.05
      end
    end
  end
  
end