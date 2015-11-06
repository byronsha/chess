require_relative "stepping_pieces"

class King < SteppingPiece

  attr_reader :value
  attr_accessor :has_moved

  def initialize(color, position, board)
    @value = "♚ " if color == :black
    @value = "♔ " if color == :white
    @has_moved = false
    super
  end

  KING_MOVES = [[1,1],[-1,-1],[-1,1],[1,-1],[1,0],[-1,0],[0,1],[0,-1]]

  def moves
    if king_side_castleable? && queen_side_castleable?
      super(KING_MOVES, [king_side_castle_move, queen_side_castle_move])
    elsif king_side_castleable?
      super(KING_MOVES, [king_side_castle_move])
    elsif queen_side_castleable?
      super(KING_MOVES, [queen_side_castle_move])
    else
      super(KING_MOVES)
    end
  end

  def king_side_castleable?
    x,y = position
    if (1..2).all? {|i| @board.grid[x][y + i].nil?} && @board.grid[x][y + 3].is_a?(Rook)
      return false if (@has_moved == true) || (@board.grid[x][y + 3].has_moved == true)
      return true unless (1..2).any? { |i| move_into_check?([x, y + i]) }
    end
    false
  end

  def queen_side_castleable?
    x,y = position
    if (1..3).all? {|i| @board.grid[x][y - i].nil?} && @board.grid[x][y - 4].is_a?(Rook)
      return false if (@has_moved == true) || (@board.grid[x][y - 4].has_moved == true)
      return true unless (1..3).any? { |i| move_into_check?([x, y - 1]) }
    end
    false
  end

  def king_side_castle_move
    return [7,6] if color == :white
    return [0,6] if color == :black
  end

  def queen_side_castle_move
    return [7,2] if color == :white
    return [0,2] if color == :black
  end
end
