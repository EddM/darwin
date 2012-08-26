#
# Standard stack collection
#
class GameStateManager
  
  attr_reader :stack
  
  def initialize
    clear
  end
  
  def clear(state = nil)
    if state
      @stack = [state]
    else
      @stack = []
    end
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
  
  def pop(n = 1)
    n.times { @stack.pop }
  end
  
end