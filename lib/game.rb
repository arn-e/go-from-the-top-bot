require_relative 'player'

class Game

  attr_reader :turn, :players, :date

	def initialize(turn = "player 1")
    @turn = turn
    @players = []
    @date = Time.now.day
  end

  def switch_turn
    @turn == "player 1" ? @turn = "player 2" : @turn = "player 1"
  end 

  def add_player(player_name)
    raise "Too many players" if @players.size == 2
    @players << new_player = Player.new(player_name)
  end


end