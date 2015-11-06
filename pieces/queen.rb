require_relative "sliding_pieces"

class Queen < SlidingPiece

  attr_reader :value

  def initialize(color, position, board)
    @value = "♕ " if color == :white
    @value = "♛ " if color == :black
    super
  end

  QUEEN_MOVES = [[1,1],[-1,-1],[-1,1],[1,-1],[1,0],[-1,0],[0,1],[0,-1]]

  def moves
    super(QUEEN_MOVES)
  end

end
