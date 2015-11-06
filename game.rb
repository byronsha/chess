require_relative "board"
require_relative "cursorable"
require_relative "display"
require_relative "pieces"
require_relative "humanplayer"
require_relative "computerplayer"

class Game
  attr_reader :display, :board, :display, :current_player

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @player1 = HumanPlayer.new(:white, @display)
    # @player2 = HumanPlayer.new(:black, @display)
    @player2 = ComputerPlayer.new(:black, @board)
    @current_player = @player1
  end

  def play
    until game_over?
      play_turn
    end

    @display.render
    puts "Game Over!"
  end

  def play_turn
    @display.render
    begin
      from_position = @current_player.play_turn
      to_position = @current_player.play_turn
      @board.move(from_position, to_position, @current_player)
    rescue RuntimeError => e
      @display.error_message = e.message
      retry
    end

    @display.error_message = nil
    switch_player
  end

  def game_over?
    [:black, :white].any? { |color| @board.checkmate?(color) }
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end

g = Game.new
g.play
