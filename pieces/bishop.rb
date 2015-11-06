require_relative "sliding_pieces"

class Bishop < SlidingPiece

  attr_reader :value

  def initialize(color, position, board)
    @value = "♗ " if color == :white
    @value = "♝ " if color == :black
    super
  end

  BISHOP_MOVES = [[1,1],[-1,-1],[-1,1],[1,-1]]

  def moves
    super(BISHOP_MOVES)
  end
end
