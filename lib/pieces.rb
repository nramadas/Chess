module Chess
	class Piece
		DIAGONAL = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  	STRAIGHT = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  	KNIGHT = [[-1, -2], [-2, -1], [-2, 1], [-1, 2],
        			[1, 2], [2, 1], [2, -1], [1, -2]]
    BLACK_PAWN = [[1, -1], [1, 0], [1, 1], [2, 0]]
    WHITE_PAWN = [[-1, -1], [-1, 0], [-1, 1], [-2, 0]]
  	ALL = DIAGONAL + STRAIGHT

		attr_accessor :row, :col
		attr_reader :player, :board, :move_type

		def initialize(row, col, player, board)
			@row, @col = row, col
			@player, @board = player, board
			@board.layout[@row][@col] = self
			@board.pieces << self
			@move_type = nil
		end

		def possible_positions(move_type, row, col)
	    possibilities = []

	    move_type.each do |pair|
	      move = { :coord => [row, col], :prev_move => nil }
	      x, y = row, col
	      while (0..7).include?(x + pair[0]) && (0..7).include?(y + pair[1])

	        temp = move
	        move = { :coord => [x + pair[0], y + pair[1]],
	                 :prev_move => temp }

	        possibilities << move
	        x, y = x + pair[0], y + pair[1]

	        break if self.is_a?(King) || self.is_a?(Pawn)
	      end
	    end
	    possibilities
	  end

	  def move(row, col)
			if is_valid_move?(row, col)
				old_row, old_col = @row, @col

				# get rid of piece in player's collection if needed
				opponent_piece = @board.layout[row][col]
				if opponent_piece && opponent_piece.player != @player
					@board.pieces.delete(opponent_piece)
				end

				# move the pieces on the board
				@board.layout[@row][@col] = nil
				@board.layout[row][col] = self

				# set the move in the piece
				@row, @col = row, col
			else
				raise(BadMove, "That is not a valid move")
			end
		end

		def move_causes_check?(row, col)
			duplicate = @board.dup
			duplicate.layout[@row][@col].move(row, col)

			duplicate.find_king(@player).in_check?
		end

		def dup(board)
			self.class.new(@row, @col, @player, board)
		end

		def castle
			raise(BadMove, "Please use Rook to castle")
		end

		def is_valid_move?(row, col)
			# return false if non-specific piece
			return false unless @move_type

			moves = possible_positions(@move_type, @row, @col)

			# return false if trying to move in a way it can't move
			return false unless moves.any? { |mov| mov[:coord] == [row, col] }

			# return false if end position is player owned
			return false if @board.layout[row][col] && 
											@board.layout[row][col].player == @player

			# return false if trying to jump a piece
			move = moves[moves.index { |mov| mov[:coord] == [row, col] }]
			return false if is_trying_to_jump?(move[:prev_move])
		
			true
		end

		def other_player
			(@player == :white) ? :black : :white
		end

		def self_player
			(@player == :white) ? :white : :black
		end

		private

		def is_trying_to_jump?(move)
			if move[:prev_move].nil?
				false
			elsif @board.layout[move[:coord][0]][move[:coord][1]]
				true
			else
				is_trying_to_jump?(move[:prev_move])
			end
		end
	end
end