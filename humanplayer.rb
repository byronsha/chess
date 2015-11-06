require_relative 'display'
require_relative 'cursorable'

class HumanPlayer
  attr_reader :color

  def initialize(color, display)
    @color = color
    @display = display
  end

  def play_turn
    result = nil
    until result
      @display.render(@color)
      result = @display.get_input
    end

    until result.is_a?(Array)
      play_turn
    end
    result
  end
end
