class Game
  COLOURS = ["red", "green", "blue", "yellow", "purple", "orange"]
  MAX_ATTEMPTS = 10
  CODE_LENGTH = 4

  def initialize
    @attempts = 0
    @creator = nil
    @guesser = nil
    @secret_colours = []
  end

  def choose_roles
    puts "Do you want to be the (1) Code Creator or (2) Code Guesser?"
    choice = gets.chomp
    loop do
      if choice == '1'
        @creator = Player.new
        @guesser = Computer.new
        @secret_colours = @creator.create_code(COLOURS, CODE_LENGTH)
        break
      elsif choice == '2'
        @creator = Computer.new
        @guesser = Player.new
        @secret_colours = @creator.create_code(COLOURS, CODE_LENGTH)
        break
      else
        puts "Wrong input: Please enter 1 or 2 only."
        choice = gets.chomp
      end
    end
    start_game
  end

  private

  def start_game
    clear_screen
    while @attempts < MAX_ATTEMPTS do
      puts "Previous Attempts:" unless @attempts == 0
      # Optionally print a summary of previous attempts here

      guess = @guesser.guess_code(COLOURS, CODE_LENGTH)
      correct_positions = @secret_colours.zip(guess).count { |a,b| a == b }
      total_correct_colours = @secret_colours.uniq.sum { |c| [@secret_colours.count(c), guess.count(c)].min }
      correct_colours = total_correct_colours - correct_positions

      clear_screen
      puts "Attempt #{@attempts + 1}"
      puts "Your guess: #{guess.join(', ')}"
      puts "● Bagels (correct position): #{correct_positions}"
      puts "○ Picos (correct color, wrong position): #{correct_colours}\n\n"

      if correct_positions == CODE_LENGTH
        puts "Congratulations, you've guessed the secret colors!"
        break
      end

      @attempts += 1
      if @attempts == MAX_ATTEMPTS
        puts "You've reached the maximum attempts! The secret colors were: #{@secret_colours.join(', ')}."
        break
      else
        puts "Try again! (Press enter to continue...)"
        gets
        clear_screen
      end
    end
  end

  def clear_screen
    system("clear") || system("cls")
  end

end

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
    puts "Guess the secret colors (#{colours.join(', ')}):"
    guess = gets.chomp.split
    until guess.length == length && guess.all? { |g| colours.include?(g) }
      puts "Wrong input: Please enter exactly #{length} valid colours (#{colours.join(', ')})."
      guess = gets.chomp.split
    end
    guess
  end
end

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
