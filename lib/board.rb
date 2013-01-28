module Chess
	class Board
		ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

		attr_accessor :layout, :pieces

		def initialize
			@layout = Array.new(8) { Array.new(8) {nil} }
			@pieces = []
		end

		def self.convert_move(move)
			letter, number = move[0], move[1].to_i

			[(0..7).to_a.reverse[number-1], ('a'..'h').to_a.index(letter)]
		end

		def reset
			# lay down pawns
			(0..7).each do |col|
				Pawn.new(1, col, :black, self)
				Pawn.new(6, col, :white, self)
			end

			# lay down everything else
			[0,7].each do |row|
				color = (row == 0) ? :black : :white
				ROW.each_with_index do |piece_type, i|
					piece_type.new(row, i, color, self)
				end
			end
		end

		def dup
			new_board = Board.new

			new_board.layout.each_with_index do |row, r|
				row.each_with_index do |col, c|
					piece = @layout[r][c]
					piece.dup(new_board) if piece
				end
			end

			new_board
		end

		def find_king(player)
			@pieces.select do |piece|
				(piece.is_a?(King) && piece.player == player)
			end.first
		end

		def print_layout
			puts "    a    b    c    d    e    f    g    h"
			puts "  -----------------------------------------"
			@layout.each_with_index do |row, i|
				print "#{(1..8).to_a.reverse[i]} |"
				row.each do |col|
					if col
						print " #{col.token}  |"
					else
						print "    |"
					end
				end
				puts
				puts "  -----------------------------------------"
			end
		end		

	end
end