class AudioManager
    
  def initialize
    @sounds = Dir["res/*.wav"].map do |file|
      name = file.split("/")[1].split(".")[0]
      [name.to_sym, Gosu::Sample.new($window, file)]
    end

    @sounds, @playing_sounds = Hash[*@sounds.flatten], {}
  end
  
  def play!(name, exclusive = true, volume = 1.0)
    return if $mute
    name = name.to_sym
    
    if exclusive
      unless @playing_sounds[name] && @playing_sounds[name].playing?
        @playing_sounds[name] = @sounds[name].play(volume)
      end
    else
      @sounds[name].play(volume)
    end
  end
  
  def play_at_distance!(name, point1, point2, threshold = 200, exclusive = true)
    return if $mute
    distance = Gosu::distance(point1[0], point1[1], point2[0], point2[1])
    if distance < threshold
      vol = (100.0 / (threshold.to_f / distance.to_f)) / 100.to_f
      play!(name, exclusive, vol)
    end
  end
  
end