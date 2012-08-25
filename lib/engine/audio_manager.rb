class AudioManager
    
  def initialize
    @sounds = Dir["res/*.wav"].map do |file|
      name = file.split("/")[1].split(".")[0]
      [:"#{@name}", Gosu::Sample.new($window, file)]
    end

    @sounds, @playing_sounds = Hash[*@sounds.flatten], {}
  end
  
  def play!(name, exclusive = true, volume = 1.0)
    name = name.to_sym
    
    if exclusive
      unless @playing_sounds[sound] && @playing_sounds[sound].playing?
        @playing_sounds[sound] = @sounds[sound].play
      end
    else
      @sounds[sound].play
    end
  end
  
  def play_at_distance!(name, point1, point2, threshold = 200, exclusive = true)
    distance = Gosu::distance(point1[0], point1[1], point2[0], point2[1])
    if distance < threshold
      play! name, exclusive, (100.0 / (threshold.to_f / distance.to_f)) / 100.to_f
    end
  end
  
end