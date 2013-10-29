require_relative 'pieces'

class Board

  attr_accessor :board

  def initialize
    make_board
    set_board
  end

  def make_board
    @board = Array.new(8) { Array.new(8) }
  end

  def set_board
    # (0..2).each_with_index do |row, index|
    #   (0..7).each_with_index do |col, col_index|
    #     set_piece([row, col], :black) if (row + col).odd?
    #   end
    # end
    #
    # (5..7).each_with_index do |row, index|
    #   (0..7).each_with_index do |col, col_index|
    #     set_piece([row, col], :red) if (row + col).odd?
    #   end
    # end
    set_piece([1, 4], :black)
    set_piece([3, 2], :black)
    set_piece([5, 0], :black)
    set_piece([1, 6], :black)
    set_piece([3, 6], :black)

    set_piece([4, 1], :red)

    nil
  end

  def set_piece(position, color)
    i, j = position
    piece = Piece.new(color, self, position)
    @board[i][j] = piece
    piece.coords = [i, j]
  end

  def move_piece(start, finish)
    i, j = start
    x, y = finish
    @board[x][y] = @board[i][j]
    @board[x][y].position = [x, y]
    remove_piece(start)
    puts self.render
  end

  def remove_piece(position)
    i, j = position
    @board[i][j] = nil
  end

  def render
    print "  "
    ("A".."H").each { |letter| print letter.center(3, " ") }
    print "\n"
    @board.each_with_index do |row, index|
      print "#{index + 1} "
      row.each do |piece|
        print piece.nil? ? " _ " : " #{piece.symbol} "
      end
      puts "\n"
    end
    nil
  end

  def make_move(start, finish, turn)
    if piece(start).slide_moves.include?(finish)
      move_piece(start, finish)
      puts "Way to slide, slider"
    elsif piece(start).jump_moves.include?(finish)
      enemy = piece(start).jump_moves[finish]
      p finish
      p enemy
      remove_piece(enemy)
      move_piece(start, finish)
      puts "Way to kill, killer"
    else
      raise InvalidMoveError
    end
  end

  def valid?(start, finish, turn)
    piece(start) != nil && piece(start).color == turn && (piece(start).slide_moves.include?(finish) || piece(start).jump_moves.include?(finish))
  end

  def empty?(position)
    i, j = position
    @board[i][j] == nil
  end

  def piece(position)
    i, j = position
    @board[i][j]
  end
end


class InvalidMoveError < StandardError
end