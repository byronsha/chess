require_relative 'display'
require_relative 'cursorable'
require_relative 'board'
require 'byebug'

class ComputerPlayer
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
    @has_selected = nil
  end

  def play_turn
    moves_hash = available_moves
    if @has_selected == nil
      possible_pieces = select_pieces(moves_hash)
      @has_selected = possible_pieces.keys.sample
    else
      new_move = attack(moves_hash[@has_selected])
      @has_selected = nil
      new_move
    end
  end

  def attack(moves)
    attack_moves = moves.select { |move| enemy_positions.include?(move) }
    return attack_moves.sample unless attack_moves.empty?
    moves.sample
  end

  def select_pieces(moves_hash)
    available_pieces = moves_hash.select { |key, val| !val.empty? }

    attack_pieces = Hash.new { |h,k| h[k] = [] }

    available_pieces.each do |key, value|
      value.each do |pos|
        if enemy_positions.include?(pos)
          attack_pieces[key] << pos
        end
      end
    end

    # attack_pieces = available_pieces.select do |key, val|
    #   overlap = enemy_positions & val
    #   false ? overlap.empty? : true
    # end

    return attack_pieces unless attack_pieces.empty?
    available_pieces
  end

  def friend_pieces
    @board.grid.flatten.select { |piece| !piece.nil? && piece.color == @color }
  end

  def friend_positions
    friend_pieces.map { |piece| piece.position }
  end

  def enemy_pieces
    @board.grid.flatten.select { |piece| !piece.nil? && piece.color != @color }
  end

  def enemy_positions
    enemy_pieces.map { |piece| piece.position }
  end

  def available_moves
    moves_hash = Hash.new { |h,k| h[k] = [] }
    friend_pieces.each do |piece|
      moves_hash[piece.position] = piece.valid_moves
    end
    moves_hash
  end

end
