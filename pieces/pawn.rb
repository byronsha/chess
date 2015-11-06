require_relative "piece"

class Pawn < Piece

  attr_reader :value

  def initialize(color, position, board)
    @value = "♙ " if color == :white
    @value = "♟ " if color == :black
    super
  end

  def moves
    grid = @board.grid
    x,y = position
    pawn_moves = [[1,0]]
    pawn_attacks = [[1,1],[1,-1]]

    unless moved?(x, color)
      pawn_moves << [2,0]
    end

    advance(pawn_moves, x, y, grid) + attacks(pawn_attacks, x, y, grid)
  end

  def moved?(x, color)
    !(x == 1 && color == :black) && !(x == 6 && color == :white)
  end

  def advance(moves, x, y, grid)
    valid_moves = []
    moves.each do |move|
      dx, dy = move
      dx *= -1 if color == :white
      space = [x + dx, y + dy]
      if @board.in_bounds?(space)
        if grid[space[0]][space[1]].nil?
          valid_moves << space
        end
      end
    end
    valid_moves
  end

  def attacks(moves, x, y, grid)
    valid_moves = []
    moves.each do |move|
      dx, dy = move
      dx *= -1 if color == :white
      space = [x + dx, y + dy]
      if @board.in_bounds?(space) && !grid[space[0]][space[1]].nil?
        if grid[space[0]][space[1]].color != self.color
          valid_moves << space
        end
      end
    end
    valid_moves
  end
end
