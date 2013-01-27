require 'rspec'
require 'chess'

describe "Board".red do
	subject(:board) { Chess::Board.new }

	describe "Look".magenta do
		its(:layout) { should eq(Array.new(8) { Array.new(8) { nil } }) }
	end

	describe "Has basic functions".magenta do
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