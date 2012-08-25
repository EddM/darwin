class RenderedText
  
  Spacing = 2
  CharacterWidth = 21
  CharacterWidths = { 'i' => 9, 'm' => 33, 'w' => 33, '1' => 11 }
  
  def initialize(text)
    @text = text.downcase!.to_s
    @images = Hash[*Dir["res/text/*.png"].map { |file|
      name = file.split("/")[2].split(".")[0]
      [name, Gosu::Image.new($window, file, false, 0, 0, CharacterWidths[name] || CharacterWidth, 21)]
    }.flatten]
  end
  
  def text=(value)
    @text = value.downcase!.to_s
  end
  
  def draw(opacity = 1.0)
    x_offset = 0
    color = Gosu::Color.from_ahsv((opacity * 255).to_i, 0, 0, 1)
    
    @text.split(//).each do |char|
      if char == " "
        x_offset += (CharacterWidth + Spacing)
      else
        image = @images[char]
        image.draw(x_offset, 0, Z::UI, 1, 1, color)
        x_offset += (image.width + Spacing)
      end
    end
  end
  
end