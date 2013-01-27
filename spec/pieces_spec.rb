require 'rspec'
require 'chess'

describe Chess::Piece do
	describe Chess::Pawn do
		let(:player1) { double("player1", { pieces: [] }) }
		let(:player2) { double("player2", { pieces: [] }) }
		let(:board) { Chess::Board.new(player1, player2) }

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

	describe Chess::Rook do
		let(:player1) { double("player1", { pieces: [] }) }
		let(:player2) { double("player2", { pieces: [] }) }
		let(:board) { Chess::Board.new(player1, player2) }

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

	describe Chess::Bishop do
		let(:player1) { double("player1", { pieces: [] }) }
		let(:player2) { double("player2", { pieces: [] }) }
		let(:board) { Chess::Board.new(player1, player2) }

		subject(:piece) { Chess::Bishop.new(0, 4, :black, board) }

		its(:row) { should eq(0) }
		its(:col) { should eq(4) }
		its(:player) { should eq(:black) }

		describe "it has" do
			it "a bishop token" do
				piece.token == "\u265d"
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
		end

		describe "it captures" do
			before(:each) do
				Chess::Pawn.new(2, 2, :white, piece.board)
				Chess::Pawn.new(3, 7, :white, piece.board)
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
		end
	end

	describe Chess::Knight do
		let(:player1) { double("player1", { pieces: [] }) }
		let(:player2) { double("player2", { pieces: [] }) }
		let(:board) { Chess::Board.new(player1, player2) }

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

	describe Chess::Queen do
		let(:player1) { double("player1", { pieces: [] }) }
		let(:player2) { double("player2", { pieces: [] }) }
		let(:board) { Chess::Board.new(player1, player2) }

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

	describe Chess::King do
		let(:player1) { double("player1", { pieces: [] }) }
		let(:player2) { double("player2", { pieces: [] }) }
		let(:board) { Chess::Board.new(player1, player2) }

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
	end
end