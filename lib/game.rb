require_relative 'player'
require_relative 'board'

class Game

  attr_accessor :database, :board
  attr_reader :turn, :players, :date

	def initialize(player_name_1,player_name_2)
    @board = Board.new
    @players = []
    @winner = ''
    @database ='/Users/apprentice/Desktop/connect_four/db/game.db'
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
    {player_name_1 => "R", player_name_2 => "B"}
  end

  def place_attempt(column)
    if @board.valid_placement?(column)
      @board.place_chip(column, @colors[@turn])
      switch_turn
      true
    else
      false
    end
  end

  def victory?
    if @board.four_in_a_row?
      @winner = @turn
      record_game
      true
    end
    false
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

  def record_game
    db = SQLite3::Database.new(@database)
    db.execute("INSERT INTO 'game_hist' (played_on,player_one,player_two,winner) 
                VALUES (DATETIME('now'),?,?,?)", @players[0].name, @players[1].name, @winner)  
  end

  private 

  def switch_turn
    @turn == @players[0] ? @turn = @players[1] : @turn = @players[0]
  end
end

