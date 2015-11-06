require_relative "piece"

class SlidingPiece < Piece

  def initialize(color, position, board)
    super
  end

  def moves(move_directions)
    valid_moves = []
    grid = @board.grid
    x,y = position
    # debugger
    move_directions.each do |move|
      dx, dy = move
      space = [x + dx, y + dy]
      while @board.in_bounds?(space)
        if grid[space[0]][space[1]].nil?
          valid_moves << space
          space = [space[0] + dx, space[1] + dy]
        elsif grid[space[0]][space[1]].color == self.color
          break
        elsif grid[space[0]][space[1]].color != self.color
          valid_moves << space
          break
        end
      end
    end
    valid_moves
  end

end
