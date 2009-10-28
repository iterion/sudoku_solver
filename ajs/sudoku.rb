class Sudoku
  
  def initialize
    blank
  end
  
  def [](x, y)
    @data[x][y]
  end
  
  def []=(x, y, value)
    @data[x][y] = value
  end
  
  def row(row)
    @data[row]
  end
  
  def column(column)
    @data.collect do |row|
      row[column]
    end
  end
  
  def box(x, y)
    vert_box = x/3 * 3
    horz_box = y/3 * 3
    @data[vert_box,3].collect { |row| row[horz_box,3] }.flatten
  end
  
  def values_for_location(x, y)
    values = Array.new
    values += @data[x].collect { |item| item.value_or_nil }
    values += @data.collect { |row| row[y].value_or_nil }
    vert_box = x/3 * 3
    horz_box = y/3 * 3
    values += @data[vert_box,3].collect { |row| row[horz_box,3] }.flatten.collect { |item| item.value_or_nil }
    values.compact
  end
  
  def elements_for_location(x, y)
    values = Array.new
    values += @data[x].collect { |item| item.unknown_or_self }
    values += @data.collect { |row| row[y].unknown_or_self }
    vert_box = x/3 * 3
    horz_box = y/3 * 3
    values += @data[vert_box,3].collect { |row| row[horz_box,3] }.flatten.collect { |item| item.unknown_or_self }
    values.compact
  end
  
  def sudoku_array=(sudoku)
    (0..8).each do |row|
      (0..8).each do |column|
        unless sudoku[row][column].nil?
          @data[row][column].value = sudoku[row][column]
          update_frequency(sudoku[row][column])
        end
      end
    end
  end
  
  def from_dotted_line(line)
    line.split(//).each_with_index do |element, index|
      unless element == "." or index >= 81
        @data[index/9][index%9].value = element.to_i
        update_frequency(element.to_i)
      end
    end
  end
  
  def blank
    @data =  [[nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil, nil]]
    (0..80).each do |column|
      @data[column/9][column%9] = Element.new
      @data[column/9][column%9].location = column
      @data[column/9][column%9].parent = self
    end
    @frequencies_hash = {1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0}
  end
  
  def update_frequency(value)
    @frequencies_hash[value] += 1
  end
  
  def frequencies
    frequency_array = @frequencies_hash.sort { |a,b| b[1]<=>a[1] }
    frequency_array.delete_if { |i| i[1] == 9}
    frequency_array
  end
  
  def value_boxes(value)
    locations = Array.new
    (0..80).each do |location|
      row = location/9
      column = location%9
      if @data[row][column].value == value
        locations << [(row/3)*3, (column/3)*3]
      end
    end
    locations
  end
  
  def unsolved?
    @data.each do |row|
      row.each do |value|
        if value.unknown?
          return true
        end
      end
    end
    false
  end
  
  def solved?
    !unsolved?
  end
  
  def unsolved
    unsolved = Array.new
    @data.each do |row|
      row.each do |value|
        if value.unknown?
          unsolved << value
        end
      end
    end
    unsolved
  end
  
  def solved
    count = 0
    @data.each do |row|
      row.each do |value|
        if value.known?
          count += 1
        end
      end
    end
    count
  end
  
  def to_s
    @data.each do |row|
      puts row.collect {|value| value.to_s}.join(" ")
    end
  end
  
  def to_ss
    three_bar = Array.new(3, "-")
    top_row_inner = Array.new(3) { three_bar.join('') }
    puts top_row = '*' + top_row_inner.join("+") + '*'
    @data[0..2].each do |row|
      puts "|" + [row[0..2].join(''), row[3..5].join(''), row[6..8].join('')].join('|') + "|"
    end
    puts separator = "+" + top_row_inner.join("+") + "+"
    @data[3..5].each do |row|
      puts "|" + [row[0..2].join(''), row[3..5].join(''), row[6..8].join('')].join('|') + "|"
    end
    puts separator
    @data[6..8].each do |row|
      puts "|" + [row[0..2].join(''), row[3..5].join(''), row[6..8].join('')].join('|') + "|"
    end
    puts top_row
  end
  
end

class Element
  attr_accessor :location
  attr_accessor :parent
  
  def initialize
    @value = nil
    @possible = [1,2,3,4,5,6,7,8,9]
  end
  
  def unknown?
    if @value.nil?
      return true
    end
    false
  end
  
  def unknown_or_self
    @value ? nil : self  
  end
  
  def known?
    unless @value.nil?
      return true
    end
    false
  end
  
  def value
    @value ? @value : @possible
  end
  
  def value_or_nil
    @value ? @value : nil
  end
  
  def value=(value)
    unless value.nil?
      if((value >= 1) and (value <= 9))
        @value = value
        @possible = [value]
      end
    else
      @value = nil
    end
  end
  
  def possible=(value)
    @possible = value
  end
  
  def remove_possible(value)
    if @possible.length > 1
      @possible.delete(value)
    else
      return false
    end
    if @possible.length == 1
      @value = @possible.first
      @parent.update_frequency(@value)
      return @value
    end
    false
  end
  
  def to_s
    if known?
      @value.to_s
    else
      "x"
    end
  end
end




