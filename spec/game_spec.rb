require '../lib/game'
require 'SQLite3'
#require '/Users/apprentice/Desktop/connect_four/db/test.db'

describe Game do
 
  let(:game) {Game.new("player 1","player 2")}

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

    let (:board) { mock("Board", :valid_placement? => true) }

    it 'allows a player to make a placement attempt' do
      Board.any_instance.stub(:valid_placement?).and_return(true) 
      game.place_attempt(3)
    end

  end

  describe '#victory?' do

    it 'checks for for existence of win conditions' do
      Board.any_instance.stub(:four_in_a_row?).and_return(true)    
      game.victory?.should == true
    end
  end

  describe "#draw?" do

    it 'checks for draw conditions (board full)' do
      Board.any_instance.stub(:spaces_left?).and_return(false)
      game.draw?.should == true    
    end
  end

  describe "#record_game" do

  database = '/Users/apprentice/Desktop/connect_four/db/test.db' 

  let(:db) {SQLite3::Database.new(database)}

  before :each do
    Board.any_instance.stub(:four_in_a_row?).and_return(true)
    game.victory?(database)
  end

  # after :each do
  #   db.execute("DELETE FROM game_hist")
  # end

    it 'increases the row count by one' do
       db.execute("SELECT COUNT(*) FROM game_hist").should eq [[1]]
    end

    it 'records date for game' do
      year,month,day = Time.now.year.to_s, Time.now.month.to_s, Time.now.day.to_s
      day = day.insert(0,"0") if day.length == 1
      date_string = "#{year}-#{month}-#{day}"
      db.execute("SELECT date(played_on) FROM game_hist").should eq [[date_string]]
    end

    it 'records game for two players' do
      db.execute("SELECT player_one FROM game_hist").should eq [["player 1"]]
      db.execute("SELECT player_two FROM game_hist").should eq [["player 2"]]
    end

    it 'records either a win or a draw' do
      db.execute("SELECT winner FROM game_hist").should eq [["player 1"]]
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

