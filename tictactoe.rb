require 'pry-byebug'

# grid = Array.new(3) { Array.new(3, " ") }

grid = [[" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "],]

def board_display(grid)
  grid.each do |row|
    puts row.join(" | ")
  end
end

board_display(grid)

def check_win(grid)
  # state always false unless win condition met

  # check each row and column
  3.times do |i|
    if grid[i].uniq.length == 1 && grid[i].first != " "
      return true
    elsif grid.transpose[i].uniq.length == 1 && grid.transpose[i].first != " "
      return true
    end
  end

  # check diagonal
  diagonal1 = [grid[0][0], grid[1][1], grid[2][2]]
  diagonal2 = [grid[0][2], grid[1][1], grid[2][0]]
  if diagonal1.uniq.length == 1  && diagonal1.first != " "
    return true
  elsif diagonal2.uniq.length == 1  && diagonal2.first != " "
    return true
  end

  false
end

check_win(grid)

def game
end

def move
end
