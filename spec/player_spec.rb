require '../lib/player.rb'

describe Player do 
	describe "#initialize" do

    let(:player) {Player.new("Player 1")}

    it "initializes a player with a given name" do
      player.name.should == "Player 1"
    end

  end
end