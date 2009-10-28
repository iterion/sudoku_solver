load "sudoku.rb"

class SudokuSolver

  def initialize(quiet = false, line = nil)
    if line
      from_file(line)
    else
      setup
    end
    @quiet = quiet
  end
  
  def solve
    start_time = Time.now
    attempts = 0
    until attempts == 20
      find_possible
      break if @sudoku.solved?
      each_box
      break if @sudoku.solved?
      attempts += 1
    end
    end_time = Time.now
    (end_time - start_time)
  end
  
  #Get list of unknown elements and send them to the checker with corresponding values
  def find_possible
    @sudoku.unsolved.each do |current|
      row = current.location/9
      column = current.location%9
      check = @sudoku.values_for_location(row, column)
      if check_array(check, current)
        return true
      end
    end
  end
  
  def check_array(check, element)
    element.value.each do |possible|
      if check.include?(possible)
        #puts "Before #{element.value.join("-")} at [#{element.location/9}, #{element.location%9}]"
        #val = element.remove_possible(possible)
        #puts "After #{element.unknown? ? element.value.join("-") : element.value}"
        if val = element.remove_possible(possible)
          if remove_solved(element, possible)
            puts "Conclusive at [#{element.location/9}, #{element.location%9}] using #{element.value} CA" unless @quiet
            return true
          end
        end
      end
    end
    false
  end
  
  def remove_solved(element, possible)
    branched = false
    row = element.location/9
    column = element.location%9
    check = @sudoku.elements_for_location(row, column)
    check.each do |check_item|
      if check_item.unknown?
        if val = check_item.remove_possible(possible)
          puts "Conclusive at [#{element.location/9}, #{element.location%9}] using #{element.value} BRANCH" unless @quiet
          branched = true
          remove_solved(check_item, val)
        end
      end
    end
    branched
  end
  
  #Find the boxes of the most frequently known values
  def each_box
    @sudoku.frequencies.each do |frequent|
      most_frequent = frequent[0]
      locations = @sudoku.value_boxes(most_frequent)
      [0, 3, 6].each do |row|
        [0, 3, 6].each do |column|
          next if locations.include?([row, column])
          box = @sudoku.box(row, column)
          unknowns = Array.new
          box.each do |box_item|
            if box_item.unknown?
              if box_item.value.include?(most_frequent)
                unknowns << box_item
              end
            end
          end
          if unknowns.length == 1
            unknowns.first.value = most_frequent
            unknowns.first.possible = [most_frequent]
            @sudoku.update_frequency(most_frequent)
            puts "Conclusive at [#{unknowns.first.location/9}, #{unknowns.first.location%9}] using #{most_frequent} EB" unless @quiet
            unless remove_solved(unknowns.first, most_frequent)
              return
            end
          end
        end
      end
    end
  end
  
  def setup
    @sudoku = Sudoku.new()
    @sudoku.sudoku_array = [[nil,3  ,nil,nil,nil,nil,nil,nil,9],
               [nil,nil,nil,nil,8  ,7  ,2  ,3  ,nil],
               [6  ,nil,9  ,nil,4  ,nil,7  ,nil,nil],
               [nil,1  ,nil,nil,5  ,nil,4  ,nil,nil],
               [nil,nil,5  ,1  ,nil,9  ,6  ,nil,nil],
               [nil,nil,8  ,nil,7  ,nil,nil,9  ,nil],
               [nil,nil,4  ,nil,2  ,nil,3  ,nil,8  ],
               [nil,6  ,3  ,8  ,1  ,nil,nil,nil,nil],
               [8  ,nil,nil,nil,nil,nil,nil,1  ,nil]]
  end
  
  def from_file(line)
    @sudoku = Sudoku.new()
    @sudoku.from_dotted_line(line)
  end
  
  def sudoku_from_dot_array=(dot_array_string)
    temp = dot_array_string.split("<br>\n")
    temp.collect! { |row| row.split('') }
    temp.collect! do |row|
      row.collect! do |value|
        if value.eql?(".")
          value = nil
        else
          value.to_i
        end
      end
    end
    @sudoku = temp
  end
  
  def print
    @sudoku.to_ss
    puts @sudoku.solved
    @sudoku.unsolved
  end
  
  #temp
  def solved_num
    @sudoku.solved
  end
end