class Board
  BOARD_COLUMNS = 7
  BOARD_ROWS = 6
  CONNECT_NO = 4
  attr_reader :board
  attr_accessor :winner

  def initialize(rows=BOARD_ROWS,cols=BOARD_COLUMNS)
    @board = Array.new(rows) { Array.new(cols, " ") }
    @winner
  end

  def spaces_left?
    @board.flatten.include?(" ")
  end

  def valid_placement?(column)
    @board.each { |row| return true if row[column] == " " }
    false
  end

  def place_chip(column, color)
    @board.reverse!.each do |row|
      if row[column] == " "
        row[column] = color
        break
      end
    end
    @board.reverse!
    winning_move?
  end

  def winning_move?
    return true if four_in_a_column?
    return true if four_in_a_row?
    return true if four_in_a_diagonal?
    return false
  end

  def four_in_a_column?(column_contents = [])
    @board[0].each_with_index do |i, index|
      @board.each {|array| column_contents << array[index]}
      result = winning_four_combination?(column_contents)
      return true if result
      column_contents = []
    end
    false
  end

  def four_in_a_row?(result = false)
    @board.each do |row|
      result = winning_four_combination?(row)
      return true if result
    end
    false
  end

  def four_in_a_diagonal?(result = false)
    @result_array = []
    @result_array << check_diagonal_1
    @result_array << check_diagonal_2
    @result_array << check_diagonal_3
    @result_array << check_diagonal_4
    @result_array.each do |result_set|
      result_set.each {|result| return true if winning_four_combination?(result)}
    end
    false
  end

  def winning_four_combination?(array)
    contents = array.join('').match(/(R{4}|B{4})/).to_s
    if contents == "RRRR"
      @winner = "R"
      return true
    elsif contents == "BBBB"
      @winner = "B"
      return true
    else
      return false
    end
  end

  def check_diagonal_1(diags = [],all_diags = [], x = 0) # bottom left to top right
    @board.each_with_index do |i,idx|
      y, x = idx, 0
      diags << @board[y][x]
      while y > 0
        y, x = y - 1, x + 1
        diags << @board[y][x]
      end
      all_diags << diags
      diags = []
    end
    all_diags.delete_if { |diagonal| diagonal.length < 4 }
  end

  def check_diagonal_2(diags = [],all_diags = [], x = 0) # top right to bottom left
    @board.each_with_index do |i,idx|
      y, x = idx, @board.length
      diags << @board[y][x]
      while y < @board.length - 1
        y, x = y + 1, x - 1
        diags << @board[y][x]
      end
      all_diags << diags
      diags = []
    end
    all_diags.delete_if { |diagonal| diagonal.length < 4 }
  end

  def check_diagonal_3(diags = [], all_diags = [],x = 0) # bottom right to top left
    @board.each_with_index do |i,idx|
      y, x = idx, @board.length
      diags << @board[y][x]
      while y > 0
        y, x = y - 1, x - 1
        diags << @board[y][x]
      end
      all_diags << diags
      diags = []
    end
    all_diags.delete_if { |diagonal| diagonal.length < 4 }
  end

  def check_diagonal_4(diags = [], all_diags = [],x = 0) # top left to bottom right
    @board.each_with_index do |i,idx|
      y, x = idx, 0
      diags << @board[y][x]
      while y < @board.length - 1
        y, x = y + 1, x + 1
        diags << @board[y][x]
      end
      all_diags << diags
      diags = []
    end
    all_diags.delete_if { |diagonal| diagonal.length < 4 }
  end

  def to_s
    @board.each { |row| puts "#{row}\n" }
  end


end