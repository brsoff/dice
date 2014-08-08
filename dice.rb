require_relative 'models'

puts "Welcome to Dice. Please enter a name: "
name = gets.chomp

game = Game.new
player = Player.new(name)
computer = Computer.new

until computer.turn < 1
  computer.roll(computer.turn)
end

puts "Hello #{ player.name }. The computer scored a #{ computer.score }. Press 'r' to roll the dice or 'q' to quit."
input = gets.chomp

while game.in_progress
  case input
    when 'r'
      roll = player.roll(player.turn)

      if player.score > computer.score
        game.in_progress = false
        game.game_over(player.score, computer.score)
      elsif player.turn > 0
        puts "Your current score is #{ player.score }. Press 'r' to roll again or 'q' to quit."
        input = gets.chomp
      else
        game.in_progress = false
        game.game_over(player.score, computer.score)
      end
    when 'q'
      puts "Goodbye!"
      game.in_progress = false
    else
     puts "D'oh! Please press either 'r' or 'q'"
     input = gets.chomp 
  end
end
