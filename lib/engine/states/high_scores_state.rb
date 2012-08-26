require 'net/http'
require 'uri'

class HighScoresState < GameState
  
  LineSpacing = 20
  
  def initialize
    @texts = []
    @font = Gosu::Font.new($window, Gosu.default_font_name, 14)
    @title = RenderedText.new("High Scores")
    @button = Button.new(($window.width / 2) - 118, 400, :continue, Proc.new {
      $window.state_manager.pop
    })
    @earth = Gosu::Image.new($window, "res/earth.png", false, 0, 0, 640, 640)
    @color = Gosu::Color.from_ahsv(125, 0, 0, 1)
  end
  
  def update
    if !@scores && !@fetching
      begin
        get_scores
      rescue
        @show_error = true
      end
    end
    
    @button.update
  end
  
  def draw
    draw_scores if @scores
    draw_error if @show_error
    
    @button.draw
    @earth.draw 0, 0, Z::Background, 1, 1, @color
    $window.translate 50, 50 do
      @title.draw
    end
  end
  
  def draw_error
    @font.draw "Couldn't connect to high score server. :(", 50, 150, Z::UI
  end
  
  def draw_scores
    $window.translate 50, 100 do
      index = 0
      @scores.each do |score|
        @font.draw score[1][0..25], 0, index * LineSpacing, Z::UI
        @font.draw score[2], 200, index * LineSpacing, Z::UI
        index += 1
      end
    end
  end
  
  def get_scores
    @fetching = true
    
    response = Net::HTTP.start($high_score_url, 80) do |http|
      http.get '/scores'
    end    

    raise "Response was not 200, response was #{the_response.code}" if response.code != "200"
    parse_scores(response.body)
  end
  
  def parse_scores(text)
    @scores = text.split("\n").map { |line| line.split(",") }
  end
  
end