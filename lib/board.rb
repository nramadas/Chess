module Chess
	class Board
		ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

		attr_accessor :layout, :player1, :player2

		def initialize(player1, player2)
			@layout = Array.new(8) { Array.new(8) {nil} }
			@player1, @player2 = player1, player2
		end

		def self.convert_move(move)
			letter, number = move[0], move[1].to_i

			[('a'..'h').to_a.index(letter), (0..7).to_a.reverse[number-1]]
		end

		def reset
			# lay down pawns
			(0..7).each do |col|
				@player2.pieces << Pawn.new(1, col, :black, self)
				@player1.pieces << Pawn.new(6, col, :white, self)
			end

			# lay down everything else
			[0,7].each do |row|
				color = (row == 0) ? :black : :white
				player = (row == 0 ) ? @player2 : @player1
				ROW.each_with_index do |piece_type, i|
					player.pieces << piece_type.new(row, i, color, self)
				end
			end
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