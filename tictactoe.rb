require 'pry-byebug'

grid = Array.new(3) { Array.new(3, " ") }

def board_display(grid)
  grid.each do |row|
    puts row.join(" | ")
  end
end

board_display(grid)

def check_win(grid)
  # state always false unless win condition met

  grid.each_with_index do |row, i|
    if grid.uniq.length == 1 && grid.first != " "
      return true
    end
  end

  false
end

def game
end

def move
end
