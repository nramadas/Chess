require 'rspec'
require 'chess'

describe "Pawn".red do
	let(:board) { Chess::Board.new }

	subject(:piece) { Chess::Pawn.new(1, 0, :black, board) }

	its(:row) { should eq(1) }
	its(:col) { should eq(0) }
	its(:player) { should eq(:black) }

	describe "it has" do
		it "a pawn token" do
			piece.token == "\u265f"
		end
	end

	describe "it can move" do
		describe "forward" do
			it "1 space when unblocked" do
				piece.move(2,0)
				piece.row.should eq(2)
				piece.col.should eq(0)
			end

			it "2 spaces on the first move" do
				piece.move(3,0)
				piece.row.should eq(3)
				piece.col.should eq(0)
			end
		end

		describe "diagonally" do
			before(:each) do
				Chess::Pawn.new(2, 1, :white, piece.board)
			end

			it "to capture" do
				piece.move(2,1)
				piece.row.should eq(2)
				piece.col.should eq(1)
			end

			it "to capture en passant"
		end	
	end

	describe "it cannot move" do
		describe "forward" do
			before(:each) do
				Chess::Pawn.new(2, 0, :white, piece.board)
				Chess::Pawn.new(2, 1, :white, piece.board)
			end
			
			it "1 space forward when blocked" do
				expect do
					piece.move(2,0)
				end.to raise_error(Chess::BadMove)
			end

			it "forward 2 spaces after making first move" do
				piece.move(2,1)
				expect do
					piece.move(4,1)
				end.to raise_error(Chess::BadMove)
			end
		end

		describe "diagonally" do
			before(:each) do
				Chess::Pawn.new(2, 0, :white, piece.board)
			end
			
			it "when not capturing" do
				expect do
					piece.move(2,1)
				end.to raise_error(Chess::BadMove)
			end

			it "en passant if another move is made first"
		end
	end
end