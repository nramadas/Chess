require 'rspec'
require 'chess'

describe "King".red do
	let(:board) { Chess::Board.new }

	subject(:piece) { Chess::King.new(0, 4, :black, board) }

	its(:row) { should eq(0) }
	its(:col) { should eq(4) }
	its(:player) { should eq(:black) }

	describe "it has" do
		it "a king token" do
			piece.token == "\u265a"
		end
	end

	describe "it can move" do
		describe "diagonally" do
			it "left one space when unblocked" do
				piece.move(1,3)
				piece.row.should eq(1)
				piece.col.should eq(3)
			end

			it "right one space when unblocked" do
				piece.move(1,5)
				piece.row.should eq(1)
				piece.col.should eq(5)
			end
		end

		describe "straight" do
			it "forward one space when unblocked" do
				piece.move(1,4)
				piece.row.should eq(1)
				piece.col.should eq(4)
			end

			it "sideways one space when unblocked" do
				piece.move(0,5)
				piece.row.should eq(0)
				piece.col.should eq(5)
			end
		end
	end

	describe "it cannot move" do
		describe "diagonally" do
			before(:each) do
				Chess::Pawn.new(1, 3, :black, piece.board)
				Chess::Pawn.new(1, 5, :black, piece.board)
			end
			
			it "left when blocked" do
				expect do
					piece.move(1,3)
				end.to raise_error(Chess::BadMove)
			end

			it "right when blocked" do
				expect do
					piece.move(1,5)
				end.to raise_error(Chess::BadMove)
			end
		end

		describe "straight" do
			before(:each) do
				Chess::Pawn.new(1, 4, :black, piece.board)
				Chess::Pawn.new(0, 5, :black, piece.board)
			end
			
			it "forward when blocked" do
				expect do
					piece.move(1,4)
				end.to raise_error(Chess::BadMove)
			end

			it "sideways when blocked" do
				expect do
					piece.move(0,5)
				end.to raise_error(Chess::BadMove)
			end
		end
	end

	describe "it captures" do
		before(:each) do
			Chess::Pawn.new(1, 3, :white, piece.board)
			Chess::Pawn.new(1, 4, :white, piece.board)
			Chess::Pawn.new(1, 5, :white, piece.board)
			Chess::Pawn.new(0, 5, :white, piece.board)
		end
		
		it "diagonally left" do
			piece.move(1,3)
			piece.row.should eq(1)
			piece.col.should eq(3)
		end

		it "diagonally right" do
			piece.move(1,5)
			piece.row.should eq(1)
			piece.col.should eq(5)
		end
		
		it "forward" do
			piece.move(1,4)
			piece.row.should eq(1)
			piece.col.should eq(4)
		end

		it "sideways" do
			piece.move(0,5)
			piece.row.should eq(0)
			piece.col.should eq(5)
		end
	end

	describe "check" do
		let(:board) { Chess::Board.new }

		subject(:piece) { Chess::King.new(0, 4, :black, board) }


		it "correctly identifies check" do
			Chess::Rook.new(7, 4, :white, piece.board)
			piece.should be_in_check
		end

		it "doesn't let a player move into check" do
			Chess::Rook.new(7, 3, :white, piece.board)
			expect do
				piece.move(0, 3)
			end.to raise_error(Chess::BadMove)
		end
	end

	describe "checkmate" do
		let(:board) { Chess::Board.new }

		subject(:piece) { Chess::King.new(0, 4, :black, board) }

		it "correctly identifies checkmate" do
			Chess::Rook.new(0, 0, :white, piece.board)
			Chess::Rook.new(1, 0, :white, piece.board)
			piece.should be_in_checkmate
		end
	end
end