require '../lib/game'

describe Game do
 
  let(:game) {Game.new}
  let(:db) {Sqlite3::Database.new('test.db')}
  
  after(:all) do
    FileUtils.rm('test.db')
  end

	describe '#initialize' do

		it 'initialize a turn' do
			game.turn.should == "player 1"
		end

    it 'records date of game' do
      game.date.should == Time.now.day
    end
  end

  describe '#switch_turn' do 

    it 'switch player turn' do
      game.switch_turn.should == "player 2"
      game.switch_turn.should == "player 1"
    end
  end

  describe '#add_player' do

    it 'add player' do
      game.add_player("Mike")
      game.players.first.name.should eq "Mike"
    end

    it 'limits the game to two players' do
      game.add_player("Arne")
      game.add_player("Mike")
      expect {game.add_player("Third Player")}.to raise_error
    end 
	end	

  describe '#place_attempt' do

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

  describe "#record_score" do

    it 'records players game history in GameHistory database' do
      game.record_score
      db.execute("SELECT COUNT(*) FROM gamehistory")
    end

  end  

end
