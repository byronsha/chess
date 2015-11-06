require_relative "sliding_pieces"

class Rook < SlidingPiece

  attr_reader :value
  attr_accessor :has_moved

  def initialize(color, position, board)
    @value = "♖ " if color == :white
    @value = "♜ " if color == :black
    @has_moved = false
    super
  end

  ROOK_MOVES = [[1,0],[-1,0],[0,1],[0,-1]]

  def moves
    super(ROOK_MOVES)
  end

end
