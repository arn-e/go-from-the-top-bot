require_relative 'player'

class Board

  BOARD_COLUMNS = 7
  BOARD_ROWS = 6
  CONNECT_NO = 4
  EMPTY_CELL = "."
  RED_CHIP = "O"
  BLACK_CHIP = "X"

  attr_reader :board, :last_played_column, :last_played_row

  def initialize(rows=BOARD_ROWS,cols=BOARD_COLUMNS)
    @board = Array.new(rows) { Array.new(cols, EMPTY_CELL) }
    @last_played_column = 0
    @last_played_row = @board.length-1
  end

  def spaces_left?
    @board.flatten.include?(EMPTY_CELL)
  end

  def valid_placement?(column)
    @board.each { |row| return true if row[column] == EMPTY_CELL }
    false
  end

  def place_chip(column, color)
    @board.reverse.each_with_index do |row, index|
      if row[column] == EMPTY_CELL
        row[column] = color
        @last_played_column = column
        @last_played_row = @board.length-1 - index
        break
      end
    end
    winning_move?
  end

  def winning_move?
    return true if four_in_a_column?
    return true if four_in_a_row?
    return true if four_in_a_diagonal?
    return false
  end

  def four_in_a_diagonal?
    diagonal_neg_slope = []; diagonal_pos_slope = []
    neg_starting_column = @last_played_column - @last_played_row
    pos_starting_column = @last_played_column + @last_played_row
    @board.each do |row|
      if neg_starting_column >= 0
        diagonal_neg_slope << row[neg_starting_column]
      end
      neg_starting_column += 1
      if pos_starting_column >= 0
        diagonal_pos_slope << row[pos_starting_column]
        pos_starting_column -= 1
      end
    end
    diagonal_neg_slope.compact! if diagonal_neg_slope.include?(nil)
    diagonal_pos_slope.compact! if diagonal_pos_slope.include?(nil)
    neg_diagonal_result = winning_four_combination?(diagonal_neg_slope)
    pos_diagonal_result = winning_four_combination?(diagonal_pos_slope)
    return true if neg_diagonal_result
    return true if pos_diagonal_result
    false
  end

  def four_in_a_column?
    winning_four_combination?(@board.transpose[@last_played_column])
  end

  def four_in_a_row?
    winning_four_combination?(@board[@last_played_row])
  end

  def winning_four_combination?(array)
    red_win = Array.new(CONNECT_NO, RED_CHIP)
    black_win = Array.new(CONNECT_NO, BLACK_CHIP)
    result = array.each_cons(CONNECT_NO).any? { |four| four == red_win || four == black_win}
    return true if result
    false
  end

  def to_s
    @board.each { |row| puts "#{row}\n" }
  end

  def to_twitter_string(twitter_string = '|')
    @board.each do |i|
      i.each do |j|
        j == " " ? char = "." : char = j
        twitter_string << char
      end
      twitter_string << '|'
    end
    twitter_string
  end

end