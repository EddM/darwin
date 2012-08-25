class Enemy < GameObject

  JumpBackDistance = 200
  
  attr_reader :speed, :damage
  
  def initialize(x, y, player, speed = 1)
    super(x, y)
    @player = player
    @speed = speed
    @damage = 25
    @hp = 100
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
      @x -= @speed
    elsif @player.x > @x
      @facing_x = :right
      @x += @speed
    end
  end
  
  def move_y
    if @player.y < @y
      @facing_y = :top
      @y -= @speed
    elsif @player.y > @y
      @facing_y = :bottom
      @y += @speed
    end
  end
  
  def jump_back!
    @jumping_back = JumpBackDistance
  end
  
  def update
    if alive?
      move
    else
      
    end
  end
  
end