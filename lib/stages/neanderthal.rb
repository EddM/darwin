class Neanderthal < Stage
  
  def initialize(player)
    super(player)
    @range = 35
    @bone_swing = 0
    @bone_dir = 0
  end
  
  def to_s
    "Neanderthal"
  end
  
  def attack!
    unless @attacking
      @attacking = true
      @attack_dir = @player.attacking_direction
      @player.enemies_in_range(@range).each do |enemy|
        apply_attack(enemy) if !enemy.invincible?
      end
    end
  end
  
  def apply_attack(enemy)
    enemy.invincible!(100)
    enemy.damage!(40)
    enemy.jump_back! unless enemy.dead?
    $window.audio_manager.play! :hit
  end
  
  def update
    if @attacking
      @bone_swing += 5
      if @bone_swing >= 30
        @attacking = false
      end
    else
      @bone_dir = 0
      @bone_swing = -30
    end
  end
  
  def draw
    super
    draw_bone if @attacking
  end
  
  private
  
  def draw_bone
    if @attack_dir == :right 
      width = @range
      height = 15
      x = @player.right
      y = @player.mid_point_y - (height / 2)
      pivot = [@player.mid_point_x, @player.mid_point_y]
    elsif @attack_dir == :left
      width = @range
      height = 15
      x = @player.x - width
      y = @player.mid_point_y - (height / 2)
      pivot = [@player.mid_point_x, @player.mid_point_y]
    elsif @attack_dir == :up
      width = 15
      height = @range
      x = @player.mid_point_x - (width / 2)
      y = @player.y - height
      pivot = [@player.mid_point_x, @player.mid_point_y]
    elsif @attack_dir == :down
      width = 15
      height = @range
      x = @player.mid_point_x - (width / 2)
      y = @player.bottom
      pivot = [@player.mid_point_x, @player.mid_point_y]
    end

    $window.rotate @bone_swing, pivot[0], pivot[1] do
      $window.draw_quad x, y, Gosu::Color::RED,
                        x + width, y, Gosu::Color::RED,
                        x, y + height, Gosu::Color::RED,
                        x + width, y + height, Gosu::Color::RED
    end
  end
  
end