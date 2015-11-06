require_relative "stepping_pieces"

class Knight < SteppingPiece

  attr_reader :value

  def initialize(color, position, board)
    @value = "♞ " if color == :black
    @value = "♘ " if color == :white
    super
  end

  KNIGHT_MOVES = [[2,1],[2,-1],[-2,-1],[-2,1],[1,2],[1,-2],[-1,-2],[-1,2]]

  def moves
    super(KNIGHT_MOVES)
  end


end
