require_relative 'player'
require_relative 'board'
require 'SQLite3'

class Game

  attr_accessor :database, :board
  attr_reader :turn, :players, :date

  def initialize(player_name_1,player_name_2)
    @board = Board.new
    @players = []
    @winner = ''
    @database ='../db/game.db'
    @players = add_player(player_name_1,player_name_2)
    p "players are : #{@players.to_s}"
    @colors = set_player_color(player_name_1,player_name_2)
    @turn = player_name_1
  end

  def add_player(player_name_1,player_name_2,players = [])
    players << new_player = Player.new(player_name_1)
    players << new_player = Player.new(player_name_2)
    players
  end

  def set_player_color(player_name_1,player_name_2)
    {player_name_1 => "R", player_name_2 => "B"}
  end

  def place_attempt(column)
    puts "debug : column : #{column}"
    if @board.valid_placement?(column)
      @board.place_chip(column, @colors[@turn])
      # switch_turn
      true
    else
      false
    end
  end

  def victory?
    if @board.winning_move?
      @winner = @turn
      record_game
      true
    else
      false
    end
  end

  def draw?
    if @board.spaces_left?
     false
    else
      @winner = "Draw"
      record_game
      true
    end
  end

  def game_stats(player_name)
    db = SQLite3::Database.new(@database)
    wins = db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = '#{player_name}' OR player_two = '#{player_name}') AND winner = '#{player_name}'").first.first
    losses = db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = '#{player_name}' OR player_two = '#{player_name}') AND (winner NOT LIKE '#{player_name}' AND winner NOT LIKE 'Draw')").first.first
    draws =  db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = '#{player_name}' OR player_two = '#{player_name}') AND winner = 'Draw'").first.first  
    puts "#{player_name}, you have #{wins} wins, #{losses} losses and #{draws} draws."
  end


  def record_game
    db = SQLite3::Database.new(@database)
    db.execute("INSERT INTO 'game_hist' (played_on,player_one,player_two,winner)
                VALUES (DATETIME('now'),?,?,?)", @players[0].name, @players[1].name, @winner)
  end

  def switch_turn
    @turn == @players[0].to_s ? @turn = @players[1].to_s : @turn = @players[0].to_s
  end
end

