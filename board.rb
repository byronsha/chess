require_relative "display"
require_relative "humanplayer"
require_relative "computerplayer"

class Board
  attr_reader :grid

  def initialize(populate_pieces = true)
    @grid = Array.new(8) { Array.new(8) }
    place_pieces if populate_pieces
  end

  def place_pieces
    starting_pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    starting_pieces.each_with_index do |piece, col|
      @grid[0][col] = piece.new(:black, [0,col], self)
      @grid[7][col] = piece.new(:white, [7,col], self)
      @grid[1][col] = Pawn.new(:black, [1,col], self)
      @grid[6][col] = Pawn.new(:white, [6,col], self)
    end
  end

  def move(start, end_pos, current_player)
    piece = @grid[start[0]][start[1]]

    if piece.nil?
      fail
    end

    if piece.color != current_player.color
      fail "Wrong color!"
    end

    end_piece = @grid[end_pos[0]][end_pos[1]]
    unless end_piece.nil?
      if end_piece.color == piece.color
        fail "Can't take your own piece!"
      end
    end

    if piece.valid_moves.include?(end_pos)
      @grid[start[0]][start[1]] = nil
      @grid[end_pos[0]][end_pos[1]] = piece
      piece.position = [end_pos[0], end_pos[1]]
    else
      fail "Can't move there!"
    end

    castle(start, end_pos, piece.color) if piece.is_a?(King)

    promote(piece, end_pos) if piece.class == Pawn

    if piece.is_a?(King) || piece.is_a?(Rook)
      piece.has_moved = true
    end

  end

  def castle(start, end_pos, color)
    row = color == :white ? 7 : 0

    if start == [row,4] && end_pos == [row,6]
      rook = @grid[row][7]
      @grid[row][5] = rook
      @grid[row][7] = nil
      rook.position = [row, 5]
    end

    if start == [row,4] && end_pos == [row,2]
      rook = @grid[row][0]
      @grid[row][3] = rook
      @grid[row][0] = nil
      rook.position = [row,3]
    end
  end

  def promote(piece, end_pos)
    x,y = end_pos
    if piece.color == :white && x == 0
      @grid[x][y] = Queen.new(:white, [x,y], self)
    elsif piece.color == :black && x == 7
      @grid[x][y] = Queen.new(:black, [x,y], self)
    end
  end

  def move!(start, end_pos)
    piece = @grid[start[0]][start[1]]

    @grid[start[0]][start[1]] = nil
    @grid[end_pos[0]][end_pos[1]] = piece
    piece.position = [end_pos[0], end_pos[1]]
  end

  def in_bounds?(pos)
    pos.all? {|el| el.between?(0,7)}
  end

  def in_check?(color)
    king = find_piece { |piece| !piece.nil? && piece.color == color && piece.class == King}
    enemy_pieces = find_piece {|piece| !piece.nil? && piece.color != color}

    enemy_pieces.any? do |piece|
      piece.moves.include?(king[0].position)
    end
  end

  def checkmate?(color)
    own_pieces = find_piece {|piece| !piece.nil? && piece.color == color}
    own_pieces.all? {|piece| piece.valid_moves.empty?}
  end

  def find_piece(&prc)
    @grid.flatten.select(&prc)
  end

  def fake_board
    fake_board = Board.new(false)
    (0..7).each do |row|
      (0..7).each do |col|
        unless self.grid[row][col].nil?
          fake_board.grid[row][col] = self.grid[row][col].dup_piece(fake_board)
        end
      end
    end
    fake_board
  end
end
