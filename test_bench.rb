load "utilities.rb"
load "sudoku_solver.rb"

s = SudokuSolver.new(true)

times = Array.new
fail = Array.new
succeed = Array.new
file = File.new("puzzles/subig20", "r")
i = 0
while (line = file.gets)
  if s.from_file(line)
    times << s.solve
    if s.solved_num < 81
      fail << i 
    else
      succeed << i
    end
  end
  i += 1
  break if i > 500
end
 
 
puts "#{times.length} iterations took #{times.sum} seconds (mean: #{times.mean}, median: #{times.median}, std-dev: #{times.deviation})."
puts fail.join(",")
puts fail.length.to_f/times.length.to_f
puts succeed.join(",")
