class GamePlay
  attr_accessor :game, :player, :computer

  def initialize
    @game = Game.new
    @player = Player.new(get_name)
    @computer = Computer.new
  end

  def get_name
    puts "Welcome to Dice. Please enter a name: "
    gets.chomp
  end

  def greet
    puts "Hello #{ @player.name }"
  end

  def begin
    @computer.roll(@computer.turn)  until @computer.turn < 1

    puts "The computer scored a #{ @computer.score }. Press 'r' to roll the dice or 'q' to quit."
    input = gets.chomp

    while @game.in_progress
      case input
        when 'r'
          @player.roll(@player.turn)

          if @player.score > @computer.score
            @game.in_progress = false
            @game.game_over(@player.score, @computer.score)
          elsif @player.turn > 0
            puts "Your current score is #{ @player.score }. Press 'r' to roll again or 'q' to quit."
            input = gets.chomp
          else
            @game.in_progress = false
            @game.game_over(@player.score, @computer.score)
          end
        when 'q'
          puts "Goodbye!"
          @game.in_progress = false
        else
         puts "D'oh! Please press either 'r' or 'q'"
         input = gets.chomp
      end
    end
  end
end

class Game
  attr_accessor :in_progress

  def initialize
    @in_progress = true
  end

  def game_over(score, compscore)
    if score == compscore
      puts "Game over! You tied the computer with a score of #{ score }"
    elsif score < compscore
      puts "You win! You scored a #{ score } and the computer scored a #{ compscore }"
    else
      puts "You lose! You scored a #{ score } and the computer scored a #{ compscore }"
    end
  end
end

class Die
  def self.roll
    [1, 2, 3, 4, 5, 6].sample
  end
end

class Player
  attr_accessor :name, :score, :turn, :current_roll

  def initialize(name = nil)
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
      choices = [@current_roll.first]
    else
      puts "Which one(s) would you like to keep? (separate with commas)"
      input = gets.chomp.split(",")

      choices = []
      input.each { |n| @current_roll[n.to_i - 1] == 3 ? choices << 0 : choices << @current_roll[n.to_i - 1] }
    end

    tally(choices)
  end

  def tally(choices)
    total = 0
    choices.each { |n| total += n }

    @score += total
    @current_roll = []

    @turn -= choices.count
  end
end

class Computer < Player
  def roll(num)
    num.times { @current_roll << Die.roll }

    if @turn == 1
      choices = [1]
    else
      if @current_roll.include?(3)
       threes = @current_roll.select { |n| n == 3 }
       choices = threes.each_with_index { |n, i| threes[i] = 0 }
      else
       choices = [@current_roll.min]
      end
    end

    tally(choices)
  end
end
