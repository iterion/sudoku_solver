load "sudoku_solver.rb"
s = SudokuSolver.new(true)
time = 0.0
1000.times do |a|
  s.setup
  time += s.solve
end

avg = time/1000.0

puts avg
  