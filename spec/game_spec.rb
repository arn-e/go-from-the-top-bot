require '../lib/game'
require '../lib/board'
require 'SQLite3'

describe Game do
 
  let(:game) {Game.new("player 1","player 2")}
  let(:board) {game.board}

 	describe '#initialize' do
		it 'initialize a turn' do
			game.turn.should == "player 1"
		end
  end

  describe '#add_player' do

    it 'adds two players to the game' do
      game.players[0].name.should eq "player 1"
      game. players[1].name.should eq "player 2"
    end 
	end	

  describe '#place_attempt' do
    it 'allows a player to make a placement attempt' do
      game.place_attempt(3)
    end
  end

  describe '#victory?' do

    it 'checks for for existence of win conditions' do
      game.victory?.should == false
    end
  end

  describe "#draw?" do

    it 'checks for draw conditions (board full)' do
      game.draw?.should == false    
    end
  end

  describe "Game_Hist database" do

    database = '/Users/apprentice/Desktop/connect_four/db/test.db' 

    let(:db) {SQLite3::Database.new(database)}

    before :each do
      game.board.board[5][0] = "R"
      game.board.board[5][1] = "R"
      game.board.board[5][2] = "R"
      game.board.board[5][3] = "R"
      game.database = '/Users/apprentice/Desktop/connect_four/db/test.db' 
      game.victory?
    end

    after :each do
      db.execute("DELETE FROM game_hist")
    end

    describe '#record_game' do

      it 'increases the row count by one' do
        db.execute("SELECT COUNT(*) FROM game_hist").should eq [[1]]
      end

      it 'records game for two players' do
        db.execute("SELECT player_one FROM game_hist").should eq [["player 1"]]
        db.execute("SELECT player_two FROM game_hist").should eq [["player 2"]]
      end

      it 'records a win' do
        db.execute("SELECT winner FROM game_hist").should eq [["player 1"]]
      end

    describe "#game_stats" do

      it 'returns number of player wins' do
        db.execute("SELECT COUNT(*) FROM game_hist WHERE player_one = 'player 1' OR player_two = 'player 1' AND winner = 'player 1'").should eq [[1]]
      end

      it 'returns number of player draws' do
        db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = 'player 1' OR player_two = 'player 1') AND winner = 'draw'").should eq [[0]]
      end

      it 'returns number of player losses' do
        db.execute("SELECT COUNT(*) FROM game_hist WHERE (player_one = 'player 1' OR player_two = 'player 1') AND winner = 'player 2'").should eq [[0]]
      end
    end
  end
end
 
end

# Robert's stuff
# before :each do
  #   Board.stub(:new).and_return(mock_board)
  # end

      # before :each do
    #   mock_board.stub(:valid_placement?).and_return(true)
    #   mock_board.stub(:game_over?).and_return(false)
    # end
# let(:mock_board) { mock("Board", :valid_placement? => true) }



    # it 'records date for game' do
    #   year,month,day = Time.now.year.to_s, Time.now.month.to_s, Time.now.day.to_s
    #   day = day.insert(0,"0") if day.length == 1
    #   date_string = "#{year}-#{month}-#{day}"
    #   db.execute("SELECT date(played_on) FROM game_hist").should eq [[date_string]]
    # end
      # Board.any_instance.stub(:valid_placement?).and_return(true) 

          # let (:board) { mock("Board", :valid_placement? => true) }