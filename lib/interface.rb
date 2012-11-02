require './game.rb'
require './board.rb'

class Interface

  def initialize(player_name_1, player_name_2)
    @game = Game.new(player_name_1,player_name_2)
    start_connect_four
  end

  def self.setup_game
    puts "Welcome to Connect 4"
    # puts "Would you like to see player history?"
    # puts "How many players?"
    puts "What is the first player's name?"
    player_1 = gets.chomp
    # player_1 = "player one"
    puts "What is the second player's name?"
    player_2 = gets.chomp
    # player_2 = "number two"
    self.new(player_1,player_2)
  end

  def start_connect_four
    print_board
    unless @game.victory? || @game.draw?
      player_turn
      start_connect_four
    end
    announce_winner
  end

  def announce_winner
    puts "congratulations!  #{@game.turn} is the winner!"
    Kernel::exit
  end

  def player_turn
    puts "it is #{@game.turn}'s turn :"
    print "Where would you like to go? "
    column_choice = gets.chomp.to_i
    if !@game.place_attempt(column_choice-1)
      player_turn
    end
    print_board
    p @game.victory?
    if @game.victory?
      announce_winner
    end
    @game.switch_turn
  end

  def print_board
    puts "  1    2    3    4    5    6    7"
    puts "---------------------------------"
    line = ""
    @game.board.board.each do |row|
      row.each do |position|
        line += "  #{position}  "
      end
      puts line
      line = ""
    end
  end

end


Interface.setup_game
