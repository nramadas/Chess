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

				if piece.is_valid_move?(@row, @col)
					return true
				end
			end

			false
		end

		def in_checkmate?
			duplicate = @board.dup
			pieces_copy = @board.pieces.dup

			@board.pieces.each do |piece|
				next unless piece.player == @player

				piece.possible_positions(piece.move_type,
																 piece.row,
																 piece.col).each do |pos|
					begin
						piece.move(pos[:coord][0], pos[:coord][1])
						@board.layout = duplicate.layout
						@board.pieces = pieces_copy
						return false
					rescue BadMove
						next
					end
				end
			end

			true
		end
	end
end