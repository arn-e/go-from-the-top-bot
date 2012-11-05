require_relative 'player'
require_relative 'board'
require 'SQLite3'

class Game

  PLAYER_ONE_CHIP = "O"
  PLAYER_TWO_CHIP = "X"

  attr_accessor :database, :board
  attr_reader :turn, :players, :date

  def initialize(player_name_1,player_name_2)
    @board = Board.new
    @players = []
    @winner = ''
    @database ='../db/game.db'
    @players = add_player(player_name_1,player_name_2)
    @colors = set_player_color(player_name_1,player_name_2)
    @turn = player_name_1
  end

  def add_player(player_name_1,player_name_2,players = [])
    players << new_player = Player.new(player_name_1)
    players << new_player = Player.new(player_name_2)
    players
  end

  def set_player_color(player_name_1,player_name_2)
    {player_name_1 => PLAYER_ONE_CHIP, player_name_2 => PLAYER_TWO_CHIP}
  end

  def place_attempt(column)
    if @board.valid_placement?(column)
      @board.place_chip(column, @colors[@turn])
      true
    else
      false
    end
  end

  def victory?
    result = false
    @board.winning_move? ? (@winner = @turn; record_game; result = true) : result = false
    result
  end

  def four_circles?
    @board.winning_move? ? true : false
  end

  def draw?
    result = false
    @board.spaces_left? ? result = false : (@winner = "Draw"; record_game; result = true)
  end

  def game_stats(player_name)
    db = SQLite3::Database.new(@database)
    wins = db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = '#{player_name}' OR player_two = '#{player_name}') AND winner = '#{player_name}'").first.first
    losses = db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = '#{player_name}' OR player_two = '#{player_name}') AND (winner NOT LIKE '#{player_name}' AND winner NOT LIKE 'Draw')").first.first
    draws =  db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = '#{player_name}' OR player_two = '#{player_name}') AND winner = 'Draw'").first.first
    puts "#{player_name}, you have #{wins} wins, #{losses} losses and #{draws} draws."
  end
  #
  #
  def record_game
    db = SQLite3::Database.new(@database)
    db.execute("INSERT INTO 'game_hist' (played_on,player_one,player_two,winner)
                VALUES (DATETIME('now'),?,?,?)", @players[0].name, @players[1].name, @winner)
  end

  def switch_turn
    p "switch turn called (game class)"
    @turn == @players[0].to_s ? @turn = @players[1].to_s : @turn = @players[0].to_s
  end
end