#! /usr/bin/ruby

load "sudoku.rb"

class SudokuCreator

	def initialize
		@sudokus = Array.new
	end

	def generate
		#set initial 9 sudoku solutions
		(1..9).each do |val|
			temp = Sudoku.new(true)
			temp[0,0] = val
			@sudokus.push(temp)
		end
		#loop through each cell in the sudoku
		(1..80).each do |n|
			tempokus = Array.new
			#@sudokus.each { |s| print s.to_ss }
			@sudokus.each do |sudoku|
				(1..9).each do |val|
					temp = Sudoku.new(true, sudoku)
					if temp.check_consistency(n/9, n%9, val)
						temp[n/9, n%9] = val
						tempokus.push(temp)
#						print "Success: [#{n/9},#{n%9}]: #{val}" 
					else
#						print "Fail [#{n/9},#{n%9}]: #{val}" 
					end
				end	
			end
			@sudokus = Array.new
			tempokus.each do |tempoku|
				@sudokus.push(tempoku)
			end
			#@sudokus.each { |s| print s.to_s }
			#gets
			print "iteration #{n}: #{@sudokus.length}\n"
		end
	end

	def print_all
		@sudokus.each do |sudoku|
			print (0..8).collect { |row| sudoku.row(row) }.flatten
		end	
	end
end

solution = SudokuCreator.new
solution.generate
solution.print_all
