load "utilities.rb"
load "sudoku_solver.rb"

s = SudokuSolver.new(true)

times = Array.new
fail = Array.new
file = File.new("puzzles/subig20", "r")
i = 0
while (line = file.gets)
  s.from_file(line)

    times << s.solve

  fail << i if s.solved_num < 81
  i += 1
  break if i > 500
end
 
 
puts "#{times.length} iterations took #{times.sum} seconds (mean: #{times.mean}, median: #{times.median}, std-dev: #{times.deviation})."
puts fail
puts fail.length.to_f/times.length.to_f
