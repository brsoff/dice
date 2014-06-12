class Game
  attr_accessor :in_progress

  def initialize
    @in_progress = true
  end

  def game_over(score)
    puts "Game over! You finished with #{ score }"
  end
end

class Die 
  def self.roll
    [1, 2, 3, 4, 5, 6].sample
  end
end

class Player
  attr_reader :name
  attr_accessor :score, :turn, :current_roll

  def initialize(name)
    @name = name
    @score = 0
    @turn = 5
    @current_roll = []
  end

  def roll(num)
    num.times { @current_roll << Die.roll } 
    
    puts "You rolled:"
    @current_roll.each_with_index { |n, i| puts "(#{ i + 1 }) #{ n }" }
   
    if @turn == 1
      choice = @current_roll.first
    else
      puts "Which one would you like to keep?"
      input = gets.chomp
      choice = @current_roll[input.to_i - 1]
      @score += choice  if choice != 3
      @current_roll = []   
    end

    @turn -= 1
  end
end

#begin game
##############################################
game = Game.new

puts "Welcome to Dice. Please enter a name: "
name = gets.chomp

player = Player.new(name)

puts "Hello #{ player.name }. Press 'r' to roll the dice or 'q' to quit."
input = gets.chomp

while game.in_progress
  case input
    when 'r'
      roll = player.roll(player.turn)

      if player.turn > 0
        puts "Your current score is #{ player.score }. Press 'r' to roll again or 'q' to quit."
        input = gets.chomp
      else
        game.in_progress = false
        game.game_over(player.score)
      end
    when 'q'
      puts "Goodbye!"
      game.in_progress = false
    else
     puts "Invalid, please press 'r' or 'q'"
     input = gets.chomp 
  end
end
