require 'rspec'
require 'chess'

describe "Queen".red do
	let(:board) { Chess::Board.new }

	subject(:piece) { Chess::Queen.new(0, 4, :black, board) }

	its(:row) { should eq(0) }
	its(:col) { should eq(4) }
	its(:player) { should eq(:black) }

	describe "it has" do
		it "a queen token" do
			piece.token == "\u265b"
		end
	end

	describe "it can move" do
		describe "diagonally" do
			it "left when unblocked" do
				piece.move(4,0)
				piece.row.should eq(4)
				piece.col.should eq(0)
			end

			it "right when unblocked" do
				piece.move(3,7)
				piece.row.should eq(3)
				piece.col.should eq(7)
			end
		end

		describe "straight" do
			it "forward when unblocked" do
				piece.move(7,4)
				piece.row.should eq(7)
				piece.col.should eq(4)
			end

			it "sideways when unblocked" do
				piece.move(0,7)
				piece.row.should eq(0)
				piece.col.should eq(7)
			end
		end
	end

	describe "it cannot move" do
		describe "diagonally" do
			before(:each) do
				Chess::Pawn.new(2, 2, :white, piece.board)
				Chess::Pawn.new(2, 6, :white, piece.board)
			end
			
			it "left when blocked" do
				expect do
					piece.move(4,0)
				end.to raise_error(Chess::BadMove)
			end

			it "right when blocked" do
				expect do
					piece.move(3,7)
				end.to raise_error(Chess::BadMove)
			end
		end

		describe "straight" do
			before(:each) do
				Chess::Pawn.new(0, 2, :white, piece.board)
				Chess::Pawn.new(4, 4, :white, piece.board)
			end
			
			it "forward when blocked" do
				expect do
					piece.move(7,4)
				end.to raise_error(Chess::BadMove)
			end

			it "sideways when blocked" do
				expect do
					piece.move(0,0)
				end.to raise_error(Chess::BadMove)
			end
		end
	end

	describe "it captures" do
		before(:each) do
			Chess::Pawn.new(2, 2, :white, piece.board)
			Chess::Pawn.new(3, 7, :white, piece.board)
			Chess::Pawn.new(2, 4, :white, piece.board)
			Chess::Pawn.new(0, 6, :white, piece.board)
		end
		
		it "diagonally left" do
			piece.move(2,2)
			piece.row.should eq(2)
			piece.col.should eq(2)
		end

		it "diagonally right" do
			piece.move(3,7)
			piece.row.should eq(3)
			piece.col.should eq(7)
		end
		
		it "forward" do
			piece.move(2,4)
			piece.row.should eq(2)
			piece.col.should eq(4)
		end

		it "sideways" do
			piece.move(0,6)
			piece.row.should eq(0)
			piece.col.should eq(6)
		end
	end
end