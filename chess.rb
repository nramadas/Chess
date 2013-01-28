#!/usr/bin/env ruby
# encoding: utf-8

require 'colorize'
require 'debugger'
require_relative 'lib/pieces.rb'
require_relative 'lib/pawn.rb'
require_relative 'lib/rook.rb'
require_relative 'lib/bishop.rb'
require_relative 'lib/knight.rb'
require_relative 'lib/queen.rb'
require_relative 'lib/king.rb'
require_relative 'lib/board.rb'
require_relative 'lib/errors.rb'

module Chess
	class Game
		def initialize
			@board = welcome
			@board.reset
		end

		def welcome
			print_title
			Board.new
		end

		def print_title
			puts
			puts "˛---˛  ˛   ˛  ˛---  ˛---˛  ˛---˛".center(44, ' ').red
			puts "|      |   |  |     |      |    ".center(44, ' ').red
			puts "|      |---|  |---  `---.  `---.".center(44, ' ').red
			puts "|      |   |  |         |      |".center(44, ' ').red
			puts "˙---˙  ˙   ˙  ˙---  ˙---˙  ˙---˙".center(44, ' ').red
			puts 
		end

		def print_instructions(player)
			puts "#{player}, please move:".red
			puts "examples: b1 c3, a1 x (to castle)"
			print "> "
		end

		def run
			current_player = :white

			while true
				@board.print_layout

				if @board.find_king(current_player).in_checkmate?
					game_over
					break
				end

				if @board.find_king(current_player).in_check?
					puts "In check!".red
				end

				print_instructions(current_player)

				start_pos, end_pos = gets.chomp.split(' ')
				start_pos = Board.convert_move(start_pos)
				end_pos = Board.convert_move(end_pos) unless end_pos == 'x'

				piece = @board.layout[start_pos[0]][start_pos[1]]

				begin
					if piece && piece.player != current_player
						puts "Cannot move opponent's piece.".red
						redo
					end
					if end_pos == 'x'
						piece.castle
					else
						unless piece.move_causes_check?(end_pos[0], end_pos[1])
							piece.move(end_pos[0], end_pos[1])
						else
							puts "Move will cause a check."
							redo
						end
					end
					current_player = piece.other_player
				rescue BadMove => b
					puts b.message.red
				  puts
				# rescue NoMethodError
				# 	puts "No piece at start location.".red
				# 	puts
				end
			end
		end

		def game_over
			puts "Checkmate!".red
			puts "Game over".red
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	game = Chess::Game.new
	game.run
end