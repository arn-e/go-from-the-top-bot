require_relative '../lib/board.rb'
require_relative '../lib/chip.rb'

describe Board do
  context "#initialize" do
    before(:each) do
      @the_board = Board.new
    end

    it "creates a new instance of board with an empty array attribute" do
      @the_board.board.should be_an_instance_of Array
    end

    it "should create the correct number of nested arrays" do
      @the_board.board.length.should == 6
    end

    it "should create nested arrays of the correct size" do
      @the_board.board[0].length.should == 7
    end
  end

  context "#spaces_left?" do
    before(:each) do
      @the_board = Board.new
    end

    it "should return true if there are spaces left" do
      @the_board.should be_spaces_left
    end

    it "should return false if there are no spaces left" do
      @the_board.board.flatten!.map! {|space| space = "X"}
      @the_board.should_not be_spaces_left
    end
  end

  context "#valid_placement?(column)" do
    before(:each) do
      @the_board = Board.new
      @the_board.board.map {|array| array[0] = "X" }
    end

    it "should return false if the column has an empty space" do
      @the_board.valid_placement?(0).should be_false
    end

    it "should return true if the column does not have an empty space" do
      @the_board.valid_placement?(1).should be_true
    end
  end

  context "#place_chip(column,color)" do
    before(:each) do
      @the_board = Board.new
    end

    it "should place a chip on the bottom if the column is empty" do
      @the_board.place_chip(0,"R")
      @the_board.board[-1][0].should == "R"
    end

    it "should place a chip at the next available space if column has chips" do
      @the_board.board[5][0] = "B"
      @the_board.board[4][0] = "R"
      @the_board.board[3][0] = "B"
      @the_board.board[2][0].should eq " "
      @the_board.place_chip(0,"B")
      @the_board.board[2][0].should == "B"
    end
  end

  context "#four_in_a_row?" do
    before(:each) do
      @the_board = Board.new
    end

    it "should return false if there are no rows with four chips in a row" do
      @the_board.four_in_a_row?.should be_false
    end

    it "should return false if there are four non consecutive chips in a row" do
      @the_board.board[2][1] = "B"
      @the_board.board[2][2] = "B"
      @the_board.board[2][3] = "B"
      @the_board.board[2][5] = "B"
      @the_board.four_in_a_row?.should be_false
    end

    it "should return true if there are four chips in a row" do
      @the_board.board.first.map! { |elem| elem = "B"}
      @the_board.four_in_a_row?.should be_true
    end
  end

  context "#four_in_a_column?" do
    before(:each) do
      @the_board = Board.new
    end

    it "should return false if there are no columns with four consecutive chips" do
      @the_board.four_in_a_column?.should be_false
    end

    it "should return false if there are four non consecutive chips in a column" do
      @the_board.board[1][3] = "B"
      @the_board.board[2][3] = "B"
      @the_board.board[3][3] = "B"
      @the_board.board[5][3] = "B"
      @the_board.four_in_a_column?.should be_false
    end

    it "should return true if there are four consecutive chips in a column" do
      @the_board.board[0][1] = "B"
      @the_board.board[1][1] = "B"
      @the_board.board[2][1] = "B"
      @the_board.board[3][1] = "B"
      @the_board.four_in_a_column?.should be_true
    end
  end

  context "#winning_four_combination?(array)" do
    before(:each) do
      @the_board = Board.new
      @winning_array = [" ", " ", "B", "B", "B", "B", "R"]
      @losing_array = [" ", "B", "R", "B", "R", " ", " "]
    end

    it "should return false if there are not four consecutive chips" do
      @the_board.winning_four_combination?(@losing_array).should be_false
    end

    it "should return true if there are four consecutive chips" do
      @the_board.winning_four_combination?(@winning_array).should be_true
    end
  end

  context "checking the four diagonal methods" do
    before(:each) do
      @the_board = Board.new
      @the_board.board[0] = ["a","b","c","d","e","f","g"]
      @the_board.board[1] = ["h","i","j","k","l","m","n"]
      @the_board.board[2] = ["o","p","q","r","s","t","u"]
      @the_board.board[3] = ["v","w","x","y","z","A","B"]
      @the_board.board[4] = ["C","D","E","F","G","H","I"]
      @the_board.board[5] = ["J","K","L","M","N","O","P"]
    end

    context "#check_diagonal_1" do
      it "should return an array of all the diagonals from BL to TR" do
        diagonals_1 = %w(J D x r l f)
        diagonals_2 = %w(C w q k e)
        @the_board.check_diagonal_1.include?(diagonals_1).should be_true
        @the_board.check_diagonal_1.include?(diagonals_2).should be_true
      end
    end

    context "#check_diagonal_2" do
      it "should return an array of all the diagonals from TR to BL" do
        diagonals_1 = %w(u A G M)
        diagonals_2 = %w(n t z F L)
        @the_board.check_diagonal_2.include?(diagonals_1).should be_true
        @the_board.check_diagonal_2.include?(diagonals_2).should be_true
      end
    end

    context "#check_diagonal_3" do
      it "should return an array of all the diagonals from TR to BL" do
        diagonals_1 = %w(I A s k c)
        diagonals_2 = %w(B t l d)
        @the_board.check_diagonal_3.include?(diagonals_1).should be_true
        @the_board.check_diagonal_3.include?(diagonals_2).should be_true
      end
    end

    context "#check_diagonal_4" do
      it "should return an array of all the diagonals from TR to BL" do
        diagonals_1 = %w(a i q y G O)
        diagonals_2 = %w(h p x F N)
        diagonals_3 = %w(o w E M)
        @the_board.check_diagonal_4.include?(diagonals_1).should be_true
        @the_board.check_diagonal_4.include?(diagonals_2).should be_true
        @the_board.check_diagonal_4.include?(diagonals_3).should be_true
      end
    end
  end
end