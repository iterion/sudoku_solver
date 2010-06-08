#! /usr/bin/ruby

load "sudoku.rb"

class SudokuCreator

	def initialize
		@sudokus = Array.new
	end

	def generate
		#set initial 9 sudoku solutions
		(1..9).each do |val|
			temp = Sudoku.new
			temp[0,0] = val
			@sudokus.push(temp)
		end
		#loop through each cell in the sudoku
		(1..80).each do |n|
			tempokus = Array.new
			#@sudokus.each { |s| print s.to_ss }
			(1..9).each do |val|
				@sudokus.each do |sudoku|
					temp = Sudoku.new(sudoku)
					sudoku[n/9, n%9] = val
					if temp.check_consistency
						tempokus.push(temp)
						print "Success: [#{n/9},#{n%9}]: #{val}" 
					else
						print "Fail [#{n/9},#{n%9}]: #{val}" 
					end
				end	
			end
			@sudokus = Array.new(tempokus)
			@sudokus.each { |s| print s.to_ss }
		end
	end
end

solution = SudokuCreator.new
solution.generate
