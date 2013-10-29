

class Piece

  attr_accessor :coords, :color, :symbol, :position, :moves, :board

  def initialize(color, board, position)
    @color, @board, @position = color, board, position
    @symbol = "o".colorize(@color)
    @king = false
  end

  def get_moves
    moves = slide_moves + jump_moves
  end

  def slide_moves
    moves = []
    i, j = @position
    dir = (color == :black ? 1 : -1)
    [-1, 1].each do |side|
      moves << [i + dir, j + side] if @board.empty?([i + dir, j + side])
    end

    if @king
      dir = -dir
      [-1, 1].each do |side|
        moves << [i + dir, j + side] if @board.empty?([i + dir, j + side])
      end
    end
    moves
  end

  def jump_moves
    jumps = {}
    i, j = @position
    dir = (color == :black ? 1 : -1)

    [-1, 1].each do |side|
      adj = @board.piece([i + dir , j + side])
      if adj.class == Piece && adj.color != self.color
        jumps[[i + (dir * 2), j + (side * 2)]] = [i + dir , j + side] if @board.empty?([i + (dir * 2), j + (side * 2)])
      end
    end

    if @king
      dir = -dir
      [-1, 1].each do |side|
        adj = @board.piece([i + dir , j + side])
        if adj.class == Piece && adj.color != self.color
          jumps[[i + (dir * 2), j + (side * 2)]] = [i + dir , j + side] if @board.empty?([i + (dir * 2), j + (side * 2)])
        end
      end
    end
    jumps
  end

  def check_king
    if @color == :red
      @king = true if @position[0] == 0
    else
      @king = true if @position[0] == 7
    end
  end

  def perform_moves!(*move_sequence)
    @board.render
    move_sequence.each do |move|
      sleep(1)
      @board.make_move(self.position, move, self.color)
      self.check_king
      @board.render
    end
  end

  def valid_move_seq?(*move_sequence)
    start = self.position
    test_board = Array.new(8) { Array.new(8) }
    @board.board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        unless piece == nil
          test_board[i][j] = Piece.new( piece.color, test_board, [i,j] )
        end
      end
    end

    test_game = Game.new
    test_game.board.board = test_board
    test_game.board.piece(start).perform_moves!(*move_sequence)
  end




    # @board.board.each do |i|
    #   # p i
    #   i.each do |j|
    #     unless j == nil
    #       # p j
    #       # test_board.set_piece([i, j], j.color)
    #     end
    #   end
    # end
    # print "Real Board"
    # print "Test Board"
    # # p test_board


end
