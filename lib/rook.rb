module Chess
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
			if (@first_move && @board.find_king(@player).first_move)
				king_col = queen_side? ? 2 : 6
				rook_col = queen_side? ? 3 : 5

				if is_valid_move?(@row, rook_col)
					@board.layout[@row][@col] = nil
					@board.layout[@row][rook_col] = self

					king = @board.find_king(@player)

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
end