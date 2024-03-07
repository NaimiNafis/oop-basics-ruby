# frozen_string_literal: true

# Bagels : Correct Colour Correct Position
# Picos  : Correct Colour Wrong Position

colours = ["red", "green", "blue", "yellow", "purple", "orange"]
attempts = 0
max_attempts = 10
code_length = 4

secret_colours = colours.sample(code_length)

while attempts < max_attempts do
  guess = gets.chomp.downcase.split
  if guess.length != code_length && guess.all? { |g| colours.include?(g)}
    puts "Wrong input: Please enter exactly #{code_length} valid colours (#{colours.join(', ')})."
    next
  end

  # count all bagels
  correct_positions = secret_colours.zip(guess).count { |a,b| a == b }

  # only count all same colours without looking at the positions
  # let say if i guess red is 3 but the SC's red is 1, so the min count will be 1. The total should be < 4
  correct_colours = secret_colours.uniq.sum { |c| [secret_colours.count(c), guess.count(c)].min}
  correct_colours = correct_colours - correct_positions # minus to prevent double counting

  puts "Bagels: #{correct_positions}, Picos: #{correct_colours}"

  if correct_positions == code_length
    puts "Congratulations, you've guessed the secret colors!"
    break
  elsif attempts == max_attempts
    puts "You've reached the maximum attempts! The secret colors were: #{secret_colours.join(', ')}."
    break
  else
    puts "Try again!"
  end

end

class Game

  COLOURS = ["red", "green", "blue", "yellow", "purple", "orange"]
  MAX_ATTEPTS = 10
  CODE_LENGTH = 4

  def initialize
    @attempts = 0
    @creator = nil
    @guesser = nil
    @secret_colours = []
  end

end

class Player

  def initialize

  end

  def create_code

  end

  def guess_code

  end

end

class Computer

  def create_code

  end

  def guess_code

  end

end
