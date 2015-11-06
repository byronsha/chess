class Piece
  attr_reader :color, :value, :board
  attr_accessor :position

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def dup_piece(fake_board)
    dup_color = self.color
    dup_position = self.position

    self.class.new(dup_color, dup_position, fake_board)
  end

  def move_into_check?(pos)
    board_dupe = @board.fake_board
    board_dupe.move!(@position, pos)
    board_dupe.in_check?(@color)
  end

  def valid_moves
    valid_moves = self.moves
    valid_moves.select! {|move| !move_into_check?(move)}
    valid_moves
  end

end
