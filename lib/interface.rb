require 'colorize'
require_relative 'game'
require_relative 'board'
require_relative "player"
require 'SQLite3'

class Interface

RED_CHIP = "O"
BLACK_CHIP = "X" 

  attr_accessor :game, :computer

  def initialize(player_name_1, player_name_2)
    @game = Game.new(player_name_1,player_name_2)
    @computer = Computer.new
    print_board # added this so it does not print twice (post turn and before turn)...print on init
    # start_connect_four
  end

  def self.setup_game
    puts "Welcome to Connect 4"
      print "What is the first player's name? "
      player_1 = gets.chomp
      # player_1 = "Computer1"
      print "What is the second player's name? "
      # player_2 = gets.chomp
      player_2 = "Computer2"
      puts "\n"
      self.new(player_1,player_2)
  end

  def start_connect_four
    unless @game.victory? || @game.draw?
      player_turn
      @game.switch_turn unless @game.four_circles?
      start_connect_four
    end
    announce_winner
  end

  def announce_winner
    @game.draw? ? (puts "Game's a draw") : (puts "congratulations!  #{@game.turn} is the winner!")
    Kernel::exit
  end

  def player_turn(column_choice = nil)
    puts "column choice : #{column_choice}"
    if column_choice == nil
      puts "it is #{@game.turn}'s turn :"
      print "Where would you like to go? \n "
      @game.turn =~ /Computer./ ? (column_choice = @computer.pick_move(@game.board)+1) : (column_choice = gets.chomp.to_i)
    end
    if !@game.place_attempt(column_choice-1)
      player_turn
    end
    puts "stuff"
    print_board
  end

  def print_board
    puts "  1    2    3    4    5    6    7    "
    puts "---------------------------------"
    line = ""
    @game.board.board.each do |row|
      row.each do |position|
        if position == BLACK_CHIP
          line += "  #{position}  ".red
        elsif position == RED_CHIP
          line += "  #{position}  ".yellow
        else
          line += "  #{position}  "
        end
      end
      puts line
      line = ""
    end
  end

end


# Interface.setup_game
# 