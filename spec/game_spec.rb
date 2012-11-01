require '../lib/game'

describe Game do
	describe '#initialize' do

		let(:game) {Game.new}

		it 'initialize a turn' do
			game.turn.should == "player 1"
		end

    it 'records date of game' do
      game.date.should == Time.now.day
    end
  end

  describe '#switch_turn' do 

    let(:game) {Game.new}

    it 'switch player turn' do
      game.switch_turn.should == "player 2"
      game.switch_turn.should == "player 1"
    end
  end

  describe '#add_player' do

    let(:game) {Game.new}

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

    let(:game) {Game.new}

    it 'allows a player to make a placement attempt' do
      game.place_attempt
    end

  end

end