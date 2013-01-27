require 'rspec'
require 'chess'

describe "Knight".red do
	let(:board) { Chess::Board.new }

	subject(:piece) { Chess::Knight.new(0, 2, :black, board) }

	its(:row) { should eq(0) }
	its(:col) { should eq(2) }
	its(:player) { should eq(:black) }

	describe "it has" do
		it "a knight token" do
			piece.token == "\u265e"
		end
	end

	describe "it can move" do
		describe "knight-like" do
			it "left when unblocked" do
				piece.move(2,1)
				piece.row.should eq(2)
				piece.col.should eq(1)
			end

			it "right when unblocked" do
				piece.move(1,4)
				piece.row.should eq(1)
				piece.col.should eq(4)
			end
		end
	end

	describe "it can jump" do
		before(:each) do
			Chess::Pawn.new(0, 1, :black, piece.board)
			Chess::Pawn.new(1, 1, :black, piece.board)
			Chess::Pawn.new(1, 3, :white, piece.board)
			Chess::Pawn.new(0, 3, :white, piece.board)
		end

		it "over own pieces" do
			piece.move(2,1)
			piece.row.should eq(2)
			piece.col.should eq(1)
		end

		it "over opponent's pieces" do
			piece.move(1,4)
			piece.row.should eq(1)
			piece.col.should eq(4)
		end
	end

	describe "it captures" do
		before(:each) do
			Chess::Pawn.new(2, 1, :white, piece.board)
			Chess::Pawn.new(1, 4, :white, piece.board)
		end
		
		it "knight-like left" do
			piece.move(2,1)
			piece.row.should eq(2)
			piece.col.should eq(1)
		end

		it "knight-like right" do
			piece.move(1,4)
			piece.row.should eq(1)
			piece.col.should eq(4)
		end
	end
end