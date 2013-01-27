require 'rspec'
require 'chess'

describe "Rook".red do
	let(:board) { Chess::Board.new }

	subject(:piece) { Chess::Rook.new(0, 0, :black, board) }

	its(:row) { should eq(0) }
	its(:col) { should eq(0) }
	its(:player) { should eq(:black) }

	describe "it has" do
		it "a rook token" do
			piece.token == "\u265c"
		end
	end

	describe "it can move" do
		describe "straight" do
			it "forward when unblocked" do
				piece.move(7,0)
				piece.row.should eq(7)
				piece.col.should eq(0)
			end

			it "sideways when unblocked" do
				piece.move(0,7)
				piece.row.should eq(0)
				piece.col.should eq(7)
			end
		end
	end

	describe "it cannot move" do
		describe "straight" do
			before(:each) do
				Chess::Pawn.new(2, 0, :white, piece.board)
				Chess::Pawn.new(0, 2, :white, piece.board)
			end
			
			it "forward when blocked" do
				expect do
					piece.move(7,0)
				end.to raise_error(Chess::BadMove)
			end

			it "sideways when blocked" do
				expect do
					piece.move(0,7)
				end.to raise_error(Chess::BadMove)
			end
		end
	end

	describe "it captures" do
		before(:each) do
			Chess::Pawn.new(2, 0, :white, piece.board)
			Chess::Pawn.new(0, 2, :white, piece.board)
		end
		
		it "forward" do
			piece.move(2,0)
			piece.row.should eq(2)
			piece.col.should eq(0)
		end

		it "sideways" do
			piece.move(0,2)
			piece.row.should eq(0)
			piece.col.should eq(2)
		end
	end

	describe "castling" do
		before(:each) do
			Chess::King.new(0, 4, :black, piece.board)
		end

		it "is possible if it hasn't moved" do
			piece.castle
			piece.row.should eq(0)
			piece.col.should eq(3)
		end

		it "isn't possible if moved" do
			piece.move(2,0)
			piece.move(0,0)
			expect do
				piece.castle
			end.to raise_error(Chess::BadMove)
		end	
	end
end