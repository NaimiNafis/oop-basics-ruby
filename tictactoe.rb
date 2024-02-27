# frozen_string_literal: true

require 'pry-byebug'

# grid = Array.new(3) { Array.new(3, " ") }

# grid = [["X", "X", " "],
#         ["X", "X", " "],
#         [" ", " ", " "],]
grid = [['X', 'O', 'X'],
        ['X', ' ', 'O'],
        ['O', 'X', 'O']]
# labelled_grid = [["1", "2", "3"],
#                  ["4", "5", "6"],
#                  ["7", "8", "9"],]
player1 = 'X'
player2 = 'O'

def board_display(grid)
  grid.each do |row|
    puts row.join(' | ')
  end
end

# Check if win conditional mitasu or not
def check_win(grid)
  return true if winning_rows?(grid, 'X') || winning_rows?(grid, 'O') ||
                 winning_columns?(grid, 'X') || winning_columns?(grid, 'O') ||
                 winning_diagonals?(grid, 'X') || winning_diagonals?(grid, 'O')

  false
end

def winning_rows?(grid, player)
  grid.any? { |row| row.all? { |cell| cell == player } }
end

def winning_columns?(grid, player)
  grid.transpose.any? { |col| col.all? { |cell| cell == player } }
end

def winning_diagonals?(grid, player)
  diagonal1 = [grid[0][0], grid[1][1], grid[2][2]]
  diagonal2 = [grid[0][2], grid[1][1], grid[2][0]]
  diagonal1.all? { |cell| cell == player } || diagonal2.all? { |cell| cell == player }
end

def game(grid, player1, player2)
  current_player = player1
  loop do
    puts "Player '#{current_player}' : Please enter any number between cell 1~9"
    board_display(grid)
    take_turn(grid, current_player)
    # binding.pry
    if grid.all? { |row| row.all? { |cell| cell != ' ' } } # Check if all cell.full?
      puts 'All cell has been filled and No winner decided!'
      break
    elsif check_win(grid) == true
      board_display(grid)
      puts "#{current_player} Win"
      break
    end
    current_player = current_player == player1 ? player2 : player1
  end
end

def take_turn(grid, current_player)
  move = get_valid_move(grid)
  row, col = convert_move_to_position(move)
  grid[row][col] = current_player
end

def get_valid_move(grid)
  loop do
    puts 'Please enter a number between 1 and 9:'
    move = gets.chomp.to_i
    row, col = convert_move_to_position(move)
    return move if row.between?(0, 2) && col.between?(0, 2) && grid[row][col] == ' '

    puts 'Invalid move. Please try again.'
  end
end

def convert_move_to_position(move)
  row = (move - 1) / 3
  col = (move - 1) % 3
  [row, col]
end

game(grid, player1, player2)
