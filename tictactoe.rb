# frozen_string_literal: true

require 'pry-byebug'

# TicTacToe game class
class TicTacToe
  attr_reader :grid, :player1, :player2, :current_player

  def initialize
    @grid = Array.new(3) { Array.new(3, ' ') }
    @player1 = 'X'
    @player2 = 'O'
    @current_player = @player1
  end

  def board_display
    @grid.each do |row|
      puts row.join(' | ')
    end
  end

  # Get user input for move taken
  def take_turn
    move = check_valid_move
    row, col = convert_move_to_position(move)
    @grid[row][col] = @current_player
  end

  def check_valid_move
    loop do
      puts 'Please enter a number between 1 and 9:'
      move = gets.chomp.to_i
      row, col = convert_move_to_position(move)
      return move if row.between?(0, 2) && col.between?(0, 2) && @grid[row][col] == ' '

      puts 'Invalid move. Please try again.'
    end
  end

  def convert_move_to_position(move)
    row = (move - 1) / 3
    col = (move - 1) % 3
    [row, col]
  end

  # Check if win conditional mitasu or not
  def check_win
    return true if winning_rows? || winning_columns? || winning_diagonals?

    false
  end

  def winning_rows?
    @grid.any? { |row| row.all? { |cell| cell == @current_player } }
  end

  def winning_columns?
    @grid.transpose.any? { |col| col.all? { |cell| cell == @current_player } }
  end

  def winning_diagonals?
    diagonal1 = [@grid[0][0], @grid[1][1], @grid[2][2]]
    diagonal2 = [@grid[0][2], @grid[1][1], @grid[2][0]]
    diagonal1.all? { |cell| cell == @current_player } || diagonal2.all? { |cell| cell == @current_player }
  end

  # Game start
  def start
    loop do
      display_player_turn
      board_display
      take_turn
      break if game_ended?

      break if check_win_and_display_winner

      switch_player
    end
  end

  def display_player_turn
    puts "Your Turn, Player '#{@current_player}'!"
  end

  def game_ended?
    if @grid.all? { |row| row.all? { |cell| cell != ' ' } }
      puts 'All cells have been filled and No winner decided!'
      true
    else
      false
    end
  end

  def check_win_and_display_winner
    if check_win
      board_display
      puts "#{@current_player} Wins!"
      true
    else
      false
    end
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end

# Create an instance of TicTacToe and start the game
game = TicTacToe.new
game.start
