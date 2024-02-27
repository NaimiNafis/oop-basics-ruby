require 'pry-byebug'

# grid = Array.new(3) { Array.new(3, " ") }

# grid = [["X", "X", " "],
#         ["X", "X", " "],
#         [" ", " ", " "],]
grid = [["X", "O", "X"],
        ["X", " ", "O"],
        ["O", "O", "O"],]
# labelled_grid = [["1", "2", "3"],
#                  ["4", "5", "6"],
#                  ["7", "8", "9"],]
p1 = "X"
p2 = "O"

def board_display(grid)
  grid.each do |row|
    puts row.join(" | ")
  end
end

def check_win(grid)
  # state always false unless win condition met

  # check each row and column
  3.times do |i|
    if grid.any? { |row| row.all? { |cell| cell = "X" || cell = "O"} }
      return true
    elsif grid.transpose.any? { |col| col.all? { |cell| cell = "X" || cell = "O"} }
      return true
    end
  end

  # check diagonal
  diagonal1 = [grid[0][0], grid[1][1], grid[2][2]]
  diagonal2 = [grid[0][2], grid[1][1], grid[2][0]]
  if diagonal1.all? { |cell| cell = "X" || cell = "O"}
    return true
  elsif diagonal2.all? { |cell| cell = "X" || cell = "O"}
    return true
  end

  false
end


def game(grid, p1, p2)
  current_player = p1
  loop do
    puts "Player '#{current_player}' : Please enter any number between cell 1~9"
    board_display(grid)
    take_turn(grid, current_player)
    if check_win(grid) == true
      board_display(grid)
      puts "#{current_player} Win"
      break
    elsif grid.all? {|row| row.all? {|cell| cell != " "}} # Check if all cell.full?
      puts "All Cell has been filled!"
    end
    current_player = current_player == p1 ? p2 : p1
  end
end

def take_turn(grid, current_player)
  move = gets.chomp.to_i
  row = (move - 1) / 3
  col = (move - 1) % 3

  if row >= 0 && row < 3 && col >= 0 && col < 3
    if grid[row][col] == " "
      grid[row][col] = current_player
    else
      puts "That cell is already taken. Please choose another."
      take_turn(grid, current_player)
    end
  else
    puts "Please put a number between 1~9"
    take_turn(grid, current_player)
  end
end


game(grid, p1, p2)
