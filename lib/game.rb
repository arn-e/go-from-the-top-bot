require_relative 'player'

class Game

  attr_reader :turn, :players, :date

	def initialize(turn = "player 1")
    @board = Board.new
    @turn = turn
    @players = []
    @date = Time.now.day
  end

  def switch_turn
    @turn == "player 1" ? @turn = "player 2" : @turn = "player 1"
  end 

  def add_player(player_name)
    raise "Too Many Players" if @players.size == 2
    @players << new_player = Player.new(player_name)
  end

  def place_attempt(column)
    @board.valid_placement?(column)
  end

  def victory?
    @board.four_in_a_row?
  end

end

# Delete me later!
class Board

end