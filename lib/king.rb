module Chess
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

		def in_check?
			@board.pieces.each do |piece|
				next if piece.player == @player

				if piece.is_valid_move?(@row, @col, @board)
					return true
				end
			end

			false
		end

	end
end