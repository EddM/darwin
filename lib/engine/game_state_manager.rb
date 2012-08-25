class GameStateManager
  
  def initialize
    @stack = []
  end
  
  def current
    @stack[-1]
  end
  
  def previous
    @stack[-2]
  end
  
  def push(state)
    @stack << state
  end
  alias :<< :push
  
  def pop
    @stack.pop
  end
  
end