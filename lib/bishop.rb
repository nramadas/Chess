module Chess
	class Bishop < Piece
		def initialize(row, col, player, board)
			super

			@move_type = DIAGONAL
		end

		def token
			(@player == :black) ? "\u265d".blue : "\u2657".yellow
		end
	end
end