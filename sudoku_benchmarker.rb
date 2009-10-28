load "utilities.rb"
load "sudoku_solver.rb"

s = SudokuSolver.new(true)

times = Array.new
1000.times do |a|
  s.setup
  times << s.solve
end

puts "#{times.length} iterations took #{times.sum} seconds (mean: #{times.mean}, median: #{times.median}, std-dev: #{times.deviation})."
