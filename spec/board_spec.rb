require 'rspec'
require 'chess'

describe Chess::Board do
	let(:player1) { double("player1", { pieces: [] }) }
	let(:player2) { double("player2", { pieces: [] }) }

	subject(:board) { Chess::Board.new(player1, player2) }

	its(:layout) { should eq(Array.new(8) { Array.new(8) { nil } }) }

	describe "has basic functions:" do
		it "has two players" do
			board.player1.should_not be_nil
			board.player2.should_not be_nil
		end

		it "makes pieces when called" do
			board.reset
			board.layout.should_not eq (Array.new(8) { Array.new(8) { nil } })
		end

		it "prints the board" do
			board.reset
			board.print_layout
		end

		it "converts textual board positions to a row, col" do
			Chess::Board.convert_move('a8').should == [0,0]
			Chess::Board.convert_move('b7').should == [1,1]
			Chess::Board.convert_move('c6').should == [2,2]
			Chess::Board.convert_move('h1').should == [7,7]
		end
	end
end