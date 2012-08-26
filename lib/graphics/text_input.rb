class TextInput < Gosu::TextInput
  include Rect
  
  InactiveColor = 0xcc666666
  ActiveColor = 0xccff6666
  SelectColor = 0xcc0000ff
  CaretColor = 0xffffffff
  Padding = 5
  
  attr_reader :x, :y
  
  def initialize(x, y, font)
    super()
    @x, @y, @font = x, y, font
    self.text = "Enter your name here"
  end

  def draw
    background_color = $window.text_input == self ? ActiveColor : InactiveColor
    
    $window.draw_quad(x - Padding,         y - Padding,          background_color,
                      x + width + Padding, y - Padding,          background_color,
                      x - Padding,         y + height + Padding, background_color,
                      x + width + Padding, y + height + Padding, background_color, 0)

    pos_x = x + @font.text_width(self.text[0...self.caret_pos])
    sel_x = x + @font.text_width(self.text[0...self.selection_start])

    $window.draw_quad(sel_x, y,          SelectColor,
                      pos_x, y,          SelectColor,
                      sel_x, y + height, SelectColor,
                      pos_x, y + height, SelectColor, 0)

    if $window.text_input == self
      $window.draw_line(pos_x, y, CaretColor, pos_x, y + height, CaretColor, 0)
    end

    @font.draw(self.text, x, y, 0)
  end
  
  def width
    @font.text_width(self.text)
  end
  
  def height
    @font.height
  end

  def move_caret(mouse_x)
    1.upto(self.text.length) do |i|
      if mouse_x < x + @font.text_width(text[0...i])
        self.caret_pos = self.selection_start = i - 1;
        return
      end
    end

    self.caret_pos = self.selection_start = self.text.length
  end
  
end