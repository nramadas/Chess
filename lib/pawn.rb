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
end