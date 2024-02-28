# frozen_string_literal: true

require 'pry-byebug'

# Model = game state, including the grid, player turns, and checking for wins.
# View = all outputs to the console, including displaying the board and messages to the player.
# Controller = user input and integrate the Model and View by controlling the game flow aka Logic.

class PlayerModel
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

class BoardModel
  attr_accessor :grid
  attr_reader :player1, :player2, :current_player

  def initialize
    @grid = Array.new(3) { Array.new(3, ' ') }
    @player1 = PlayerModel.new('Player 1', 'X')
    @player2 = PlayerModel.new('Player 2', 'O')
    @current_player = @player1
  end

  def take_turn(row, col)
    if valid_move?(row, col)
      @grid[row][col] = @current_player.symbol
      true
    else
      false
    end
  end

  def valid_move?(row, col)
    row.between?(0, 2) && col.between?(0, 2) && @grid[row][col] == ' '
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def check_win
    player = @current_player.symbol
    winning_rows?(player) || winning_columns?(player) || winning_diagonals?(player)
  end

  def game_ended?
    @grid.all? { |row| row.none? { |cell| cell == ' ' } } || check_win
  end

  private

  def winning_rows?(player)
    @grid.any? { |row| row.all? { |cell| cell == player } }
  end

  def winning_columns?(player)
    @grid.transpose.any? { |col| col.all? { |cell| cell == player } }
  end

  def winning_diagonals?(player)
    diagonal1 = [@grid[0][0], @grid[1][1], @grid[2][2]]
    diagonal2 = [@grid[0][2], @grid[1][1], @grid[2][0]]
    diagonal1.all? { |cell| cell == player } || diagonal2.all? { |cell| cell == player }
  end
end

class DisplayView
  def display_board(grid)
    grid.each { |row| puts row.join(' | ') }
  end

  def display_instruction
    puts 'Please enter a number between 1 and 9:'
  end

  def display_error
    puts 'Invalid move. Please try again.'
  end

  def display_player_turn(player)
    puts "Your Turn, Player '#{player}'!"
  end

  def display_winner(player)
    puts "#{player} Wins!"
  end

  def display_draw
    puts 'The game ended in a draw.'
  end
end

class GameController
  def initialize
    @model = BoardModel.new
    @view = DisplayView.new
  end

  def play_game
    until @model.game_ended?
      @view.display_board(@model.grid)
      @view.display_player_turn(@model.current_player.name)
      row, col = player_move
      @model.take_turn(row, col)
      @model.switch_player unless @model.game_ended?
    end

    @view.display_board(@model.grid)

    if @model.check_win
      @view.display_winner(@model.current_player.name)
    else
      @view.display_draw
    end
  end

  def player_move
    loop do
      @view.display_instruction
      move = gets.chomp.to_i
      row, col = convert_move_to_position(move)
      return [row, col] if @model.valid_move?(row, col)

      @view.display_error
      player_move
    end
  end

  private

  def convert_move_to_position(move)
    row = (move - 1) / 3
    col = (move - 1) % 3
    [row, col]
  end
end

game = GameController.new
game.play_game
