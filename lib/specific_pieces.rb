module Chess
	class Pawn < Piece
		def initialize(row, col, player, board)
			super

			@first_move = true
			@move_type = (@player == :black) ? BLACK_PAWN : WHITE_PAWN
		end

		def token
			(@player == :black) ? "\u265f".blue : "\u2659".yellow
		end

		def move(row, col)
			super

			@first_move = false
		end

		private

		def is_valid_move?(row, col)
			# return false if trying to move 2 spaces but not first move
			return false if (row - @row).abs == 2 && !@first_move

			moves = possible_positions(@move_type, @row, @col)

			# return false if trying to move in a way pawns can't move
			return false unless moves.any? { |mov| mov[:coord] == [row, col] }

			# return false if blocked moving forward
			return false if (col == @col) && @board.layout[row][col]

			# return false if trying to jump a piece
			move = moves[moves.index { |mov| mov[:coord] == [row, col] }]
			return false if is_trying_to_jump?(move[:prev_move])

			# return false if moving diagonally and not capturing
			return false if (col != @col) && 
											(@board.layout[row][col].nil? ||
											 @board.layout[row][col].player == @player)
		
			true
		end
	end

	class Rook < Piece
		def initialize(row, col, player, board)
			super

			@move_type = STRAIGHT
			@first_move = true
		end

		def token
			(@player == :black) ? "\u265c".blue : "\u2656".yellow
		end

		def move(row, col)
			super

			@first_move = false
		end

		def castle
			if (@first_move && find_king.first_move)
				king_col = queen_side? ? 2 : 6
				rook_col = queen_side? ? 3 : 5

				if is_valid_move?(@row, 3)
					@board.layout[@row][@col] = nil
					@board.layout[@row][rook_col] = self

					king = find_king

					@board.layout[@row][4] = nil
					@board.layout[@row][king_col] = king

					@col = rook_col
					king.col = king_col
				else
					raise(BadMove, "Cannot castle: Path is blocked.")
				end
			else
				raise(BadMove, "Cannot castle: Either King or Rook has already moved.")
			end
		end

		private

		def queen_side?
			@col == 0
		end

	end

	class Bishop < Piece
		def initialize(row, col, player, board)
			super

			@move_type = DIAGONAL
		end

		def token
			(@player == :black) ? "\u265d".blue : "\u2657".yellow
		end
	end

	class Knight < Piece
		def initialize(row, col, player, board)
			super

			@move_type = KNIGHT
		end

		def token
			(@player == :black) ? "\u265e".blue : "\u2658".yellow
		end
	end

	class Queen < Piece
		def initialize(row, col, player, board)
			super
			
			@move_type = ALL
		end

		def token
			(@player == :black) ? "\u265b".blue : "\u2655".yellow
		end
	end

	class King < Piece
		attr_reader :first_move

		def initialize(row, col, player, board)
			super

			@move_type = ALL
			@first_move = true
		end

		def token
			(@player == :black) ? "\u265a".blue : "\u2654".yellow
		end

		def move(row, col)
			super

			@first_move = false
		end
	end
end