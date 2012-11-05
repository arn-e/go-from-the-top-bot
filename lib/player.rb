class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

end

class Computer < Player

  RED_CHIP = "O"
  BLACK_CHIP = "X"
  EMPTY_CELL = "."

  def initialize(name="Computer")
    @name = name
    @computer_threat = [EMPTY_CELL, RED_CHIP, RED_CHIP, EMPTY_CELL]
    @player_threat = [EMPTY_CELL, BLACK_CHIP, BLACK_CHIP, EMPTY_CELL]
  end

  def pick_move(board_instance)
    @board = board_instance
    @possible_moves = possible_moves
    @possible_safe_moves = possible_safe_moves(@possible_moves)

    return almost_four_moves(@possible_moves,RED_CHIP) unless almost_four_moves(@possible_moves,RED_CHIP) == nil
    return almost_four_moves(@possible_moves,BLACK_CHIP) unless almost_four_moves(@possible_moves,BLACK_CHIP) == nil
    return two_in_a_row_moves(@possible_safe_moves,@player_threat) unless two_in_a_row_moves(@possible_safe_moves,@player_threat) == nil
    return two_in_a_row_moves(@possible_safe_moves,@computer_threat) unless two_in_a_row_moves(@possible_safe_moves,@computer_threat) == nil

    computer_move = random_move(@possible_safe_moves)
    # x = possible_safe_moves(@possible_safe_moves)
    # puts "all possible  moves: #{@possible_moves.inspect}"
    # puts "possible safe move : #{x}"
    return computer_move

  end

  def possible_moves # returns array of possible moves... arr = [[row,col], [row,col],[row,col]]
    all_possible_moves = []
    @board.board.transpose.each_with_index do |column, column_index|
      column.each_with_index do |row, row_index|
        if column[row_index] == EMPTY_CELL && column[row_index+1] != EMPTY_CELL
          all_possible_moves << [row_index,column_index]
        end
      end
    end
    all_possible_moves
  end

  def possible_safe_moves(possible_moves)
    all_possible_safe_moves = []
    possible_moves.each { |coordinate| all_possible_safe_moves << coordinate unless single_bad_move?(coordinate) }
    all_possible_safe_moves
  end

  def random_move(array_of_moves)
    if array_of_moves.empty?
      i = rand(0..@possible_moves.length-1)
      return @possible_moves[i][1]
    else
      i = rand(0..array_of_moves.length-1)
      return array_of_moves[i][1]
    end
  end

  def single_bad_move?(coordinate)
    test_board = Marshal::load(Marshal.dump(@board))
    test_board.board[coordinate[0]][coordinate[1]] = BLACK_CHIP
    test_board.board[coordinate[0]-1][coordinate[1]] = RED_CHIP
    player_test_row = coordinate[0] - 1
    player_test_column = coordinate[1]
    test_board.winning_move?(player_test_column,player_test_row) ? (return true) : (return false)
  end

  def two_in_a_row_moves(possible_moves, almost_four_array)
    test_board = Marshal::load(Marshal.dump(@board))
    computer_final_move = nil
    test_board.board.each_with_index do |row, row_index|
      x = 0
      row.each_cons(4) do |match|
        possible_moves.each do |coordinates|
          if match == almost_four_array
            first_empty_cell_column_number = match.index(EMPTY_CELL) + x
            if first_empty_cell_column_number == coordinates[1] && row_index == coordinates[0]
              computer_final_move = first_empty_cell_column_number
              return computer_final_move
            end
          end
        end
        x += 1
      end
    end
    computer_final_move
  end

  def almost_four_moves(possible_moves,chip_type)
    test_board = Marshal::load(Marshal.dump(@board))
    computer_final_move = nil
    possible_moves.each do |coordinate|
      test_board.board[coordinate[0]][coordinate[1]] = chip_type
      computer_test_row = coordinate[0]
      computer_test_column = coordinate[1]
      if test_board.winning_move?(computer_test_column,computer_test_row)
        return computer_final_move = coordinate[1]
      end
      test_board.board[coordinate[0]][coordinate[1]] = EMPTY_CELL
    end
    computer_final_move
  end

end