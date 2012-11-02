require_relative 'player'

class Game

  attr_reader :turn, :players, :date

	def initialize(player_name_1,player_name_2,turn = "player 1")
    @board = Board.new
    @turn = turn
    @players = []
    @winner = ''
    add_player(player_name_1,player_name_2)
  end

  def add_player(player_name_1,player_name_2)
    # raise "Too Many Players" if @players.size == 2
    @players << new_player = Player.new(player_name_1)
    @players << new_player = Player.new(player_name_2)
  end

  def place_attempt(column)
    if @board.valid_placement?(column)
      switch_turn
      true
    else
      false
    end
  end

  def victory?(database='/Users/apprentice/Desktop/connect_four/db/game.db')
    if @board.four_in_a_row?
      @winner = @turn
      record_game(database)
      true
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

  def record_game(database='/Users/apprentice/Desktop/connect_four/db/game.db')
    db = SQLite3::Database.new(database)
    db.execute("INSERT INTO 'game_hist' (played_on,player_one,player_two,winner) 
                VALUES (DATETIME('now'),?,?,?)", @players[0].name, @players[1].name, @winner)  
  end

  private 

  def switch_turn
    @turn == "player 1" ? @turn = "player 2" : @turn = "player 1"
  end
end

# Delete me later!
class Board

end