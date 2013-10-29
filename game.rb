require_relative 'board.rb'
require_relative 'pieces.rb'
require 'colorize'

class Game

  attr_accessor :board

  def initialize
    @board = Board.new
    @turn = :black
  end

  def play
    print_board
    while true
      puts "It's your turn, #{@turn.to_s.upcase.colorize(@turn)}"
      get_move
      @turn = ( @turn == :black ? :red : :black )
    end
  end

  def get_pos(prompt)
    puts prompt
    move = gets.chomp
    col = move.scan(/\D/)
    row = move.scan(/\d/)
    move = [row[0].to_i - 1, col[0].downcase.ord - 97]
  end

  def get_move
    move_from = get_pos("Which piece?")
    move_to = get_pos("To where")
    until @board.valid?(move_from, move_to, @turn)
      puts "That is not a valid move"
      move_from = get_pos("Which piece?")
      move_to = get_pos("To where")
    end
    @board.make_move(move_from, move_to, @turn)
    @board.piece(move_to).check_king
  end

  def print_board
    @board.render
  end

end

game = Game.new

game.play
# game.print_board

# game.board.piece([4,1]).perform_moves!([2,3], [0,5], [2, 7],[4, 5], [3, 4], [2, 3], [3, 2]) # valid good

# game.board.piece([4,1]).perform_moves!([2,3], [1,4], [2, 7],[4, 5], [3, 4], [2, 3], [3, 2]) # invalid good


# game.board.piece([4,1]).valid_move_seq?([2,3], [0,5], [2, 7],[4, 5], [3, 4], [2, 3], [3, 2]) # valid

# game.board.piece([4,1]).valid_move_seq?([2,3], [1,4], [2, 7],[4, 5], [3, 4], [2, 3], [3, 2]) # invalid
