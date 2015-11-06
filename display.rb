require "colorize"
require_relative "board"
require_relative "cursorable"

class Display
  include Cursorable

  attr_accessor :error_message

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @cursor_last = nil
    @error_message = nil
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      if piece
        color_options = colors_for(i, j, piece.color)
        piece.value.to_s.colorize(color_options)
      else
        color_options = colors_for(i, j)
        "  ".colorize(color_options)
      end
    end
  end

  def colors_for(i, j, color = :default)
    valid_moves = show_moves(@cursor_last) unless @cursor_last.nil?

    if [i, j] == @cursor_pos
      bg = :red
    elsif [i, j] == @cursor_last
      bg = :blue
    elsif !valid_moves.nil? && valid_moves.include?([i, j])
      bg = :light_blue
    elsif (i + j).odd?
      bg = :light_black
    elsif (i + j).even?
      bg = :light_white
    end
    { background: bg, color: color }
  end

  def show_moves(pos)
    i, j = pos
    @board.grid[i][j].valid_moves unless @board.grid[i][j].nil?
  end

  def render(color = nil)
    system("clear")
    build_grid.each { |row| puts row.join }
    puts @error_message if @error_message
    puts "#{color.capitalize}'s move." if color
    check_message
  end

  def check_message
    [:black, :white].each do |color|
      if @board.checkmate?(color)
        puts "#{color.to_s.capitalize} is checkmated!"
      elsif @board.in_check?(color)
        puts "#{color.to_s.capitalize} is in check!"
      end
    end
  end
end
