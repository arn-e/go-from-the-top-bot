require './game.rb'
require './board.rb'
require './player.rb'
require 'SQLite3'

class Interface

  def initialize(player_name_1, player_name_2)
    @game = Game.new(player_name_1,player_name_2)
    @computer = Computer.new
    print_board # added this so it does not print twice (post turn and before turn)...print on init
    start_connect_four
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
    # @game.game_stats(@game.turn)
    Kernel::exit
  end

  def player_turn
    puts "it is #{@game.turn}'s turn :"
    print "Where would you like to go? \n "
    @game.turn =~ /Computer./ ? (column_choice = @computer.pick_move) : (column_choice = gets.chomp.to_i)
    if !@game.place_attempt(column_choice-1)
      player_turn
    end
    print_board
  end

  def print_board
    puts " 1    2    3    4    5    6    7"
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


# Interface.setup_game