# frozen_string_literal: true

# Game class manage game flow, including choosing roles, starting the game, and managing game attempts.
class Game
  COLOURS = %w[red green blue yellow purple orange].freeze
  MAX_ATTEMPTS = 10
  CODE_LENGTH = 4

  def initialize
    @attempts = 0
    @creator = nil
    @guesser = nil
    @secret_colours = []
    @correct_positions = 0
    @previous_attempts = []
  end

  def choose_roles
    setup_roles(role_choice)
    start_game
  end

  private

  def role_choice
    puts 'Do you want to be the (1) Code Creator or (2) Code Guesser?'
    choice = gets.chomp
    loop do
      return choice if %w[1 2].include?(choice)

      puts 'Wrong input: Please enter 1 or 2 only.'
      choice = gets.chomp
    end
  end

  def setup_roles(choice)
    if choice == '1'
      @creator = Player.new
      @guesser = Computer.new
    else
      @creator = Computer.new
      @guesser = Player.new
    end
    @secret_colours = @creator.create_code(COLOURS, CODE_LENGTH)
  end

  def start_game
    clear_screen
    while @attempts < MAX_ATTEMPTS
      display_previous_attempts
      process_guess

      break if game_over?

      prepare_next_attempt
    end
  end

  def display_previous_attempts
    puts 'Previous Attempts:' unless @previous_attempts.empty?
    @previous_attempts.each_with_index do |attempt, index|
      puts "\nAttempt #{index + 1}: Guess - #{attempt[:guess].join(', ')}"
      puts "● Bagels (correct position): #{attempt[:correct_positions]}"
      puts "○ Picos (correct color, wrong position): #{attempt[:correct_colours]}\n"
    end
  end

  def process_guess
    guess = @guesser.guess_code(COLOURS, CODE_LENGTH)
    @correct_positions, correct_colours = evaluate_guess(guess)

    @previous_attempts << { guess: guess, correct_positions: @correct_positions, correct_colours: correct_colours }

    clear_screen
    display_guess_feedback(guess, @correct_positions, correct_colours)

    @attempts += 1
  end

  def evaluate_guess(guess)
    correct_positions = @secret_colours.zip(guess).count { |a, b| a == b }
    total_correct_colours = @secret_colours.uniq.sum { |c| [@secret_colours.count(c), guess.count(c)].min }
    correct_colours = total_correct_colours - correct_positions
    [correct_positions, correct_colours]
  end

  def display_guess_feedback(guess, correct_positions, correct_colours)
    puts "Attempt #{@attempts + 1}"
    puts "Your guess: #{guess.join(', ')}"
    puts "● Bagels (correct position): #{correct_positions}"
    puts "○ Picos (correct color, wrong position): #{correct_colours}\n\n"
  end

  def game_over?
    if @correct_positions == CODE_LENGTH
      puts "Congratulations, you've guessed the secret colors!"
      true
    elsif @attempts == MAX_ATTEMPTS
      puts "You've reached the maximum attempts! The secret colors were: #{@secret_colours.join(', ')}."
      true
    else
      false
    end
  end

  def prepare_next_attempt
    puts 'Try again! (Press enter to continue...)'
    gets
    clear_screen
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

# Player class manages player actions including creating and guessing the code based on user input.
class Player
  def create_code(colours, length)
    puts "Enter your secret code (#{colours.join(', ')}):"
    code = gets.chomp.split
    until code.length == length && code.all? { |g| colours.include?(g) }
      puts "Wrong input: Please enter exactly #{length} valid colours (#{colours.join(', ')})."
      code = gets.chomp.split
    end
    code
  end

  def guess_code(colours, length)
    puts "\nGuess the secret colors (#{colours.join(', ')}):"
    guess = gets.chomp.split
    until guess.length == length && guess.all? { |g| colours.include?(g) }
      puts "Wrong input: Please enter exactly #{length} valid colours (#{colours.join(', ')})."
      guess = gets.chomp.split
    end
    guess
  end
end

# Computer class handles computer actions such as generating a secret code and making guesses.
class Computer
  def create_code(colours, length)
    colours.sample(length)
  end

  def guess_code(colours, length)
    colours.sample(length)
  end
end

game = Game.new
game.choose_roles
