require 'pry'

RPS_HANDS = %w(rock paper scissors lizard spock)
PLAY_UPTO = 5

class Score
  def initialize
    @human_score = 0
    @computer_score = 0
    @round_number = 0
  end
  
  def update(winner)
    if winner.class == Human
      @human_score += 1
    elsif winner.class == Computer
      @computer_score += 1
    end

    @round_number += 1
  end

  def display(human_name, computer_name)
    puts "After round ##{@round_number}:"
    puts "-------------------------------"
    puts "        #{human_name} : #{@human_score}"
    puts "        #{computer_name} : #{@computer_score}" 
    puts "-------------------------------"
  end

  def winner_of_set
    if @human_score == PLAY_UPTO
      "Congratulations! You won!"
    elsif @computer_score == PLAY_UPTO
      "Aww looks like you weren't lucky this around. Better luck next time!"
    else
      false
    end
  end
end

class Player
  attr_accessor :choice

  def initialize
    @choice = nil
  end
end

class Human < Player
  attr_accessor :name

  def initialize
    set_name
  end

  def set_name
    n = ''

    loop do
      puts "Please enter your user name"
      n = gets.chomp
      break unless n.empty?
    end

    self.name = n
  end

  def choose
    answer = nil

    loop do
      puts "Make your choice. rock, paper, scissors, lizard, or spock:"
      answer = gets.chomp
      break if RPS_HANDS.include?(answer)
      puts "That's an invalid choice."
    end

    self.choice = Move.new(answer)
  end
end

class Computer < Player
  attr_accessor :name

  def initialize
    set_name
  end

  def set_name
    self.name = ["R2D2", "C3PO", "WALL-E", "KAWHII"].sample
  end

  def choose
    self.choice = Move.new(RPS_HANDS.sample)
  end
end

class Move
  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def scissors?
    @value == "scissors"
  end

  def paper?
    @value == "paper"
  end

  def lizard?
    @value == "lizard"
  end

  def spock?
    @value == "spock"
  end

  def >(other_value)
    (rock? && (other_value.scissors? || other_value.lizard?)) ||
    (scissors? && (other_value.paper? || other_value.lizard?)) ||
    (paper? && (other_value.rock? || other_value.spock?)) ||
    (lizard? && (other_value.paper? || other_value.spock?)) ||
    (spock? && (other_value.rock? || other_value.scissors?))
  end

  def to_s
    @value
  end
end

class RPSgame
  attr_accessor :human, :computer, :winner, :score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    @winner = nil
  end

  # rubocop:disable Metrics/MethodLength
  def display_welcome_message
    puts <<-MSG 
    Welcome to the game of rock, paper, scissor, lizard, spock!
    Here are the rules:
    1) Scissors cuts paper and decapitates lizard
    2) Rock crushes scissors and lizard
    3) Paper covers rock and disproves Spock
    4) Lizard poisons Spock and eats paper
    5) Spock smashes scissors and vaporizes rock
    
    You will play until either you or the computer has won #{PLAY_UPTO} rounds.
    
    Press enter to start the game.

    MSG
  end
  # rubocop:enable Metrics/MethodLength

  def display_goodbye_message
    puts "Thanks for playing, #{human.name}! See you again."
  end

  def display_moves
    puts "#{human.name} chose #{human.choice}"
    puts "#{computer.name} chose #{computer.choice}."
  end

  def determine_winner
    if human.choice > computer.choice
      @winner = human
    elsif computer.choice > human.choice
      @winner = computer
    else
      @winner = nil
    end
  end

  def display_winner
    if @winner == human
      puts "#{human.name} won!"
      puts
    elsif @winner == computer
      puts "#{computer.name} won.."
      puts
    else
      puts "It's a tie!"
      puts
    end
  end

  def display_set_winner
    if @winner == human
      puts "You're ultimate winner of this set! Congrats, champ!"
    else
      puts "Looks like you weren't so lucky this set. Better luck next time!"
    end
  end

  # def play_again?
  #   puts "Would you like to play another set? (y/n)"
  #   answer = nil

  #   loop do
  #     answer = gets.chomp.downcase
  #     break if answer == 'y' || answer == 'n'
  #     puts "Invalid input. Enter either 'y' for 'yes' or 'n' for 'no'"
  #   end

  #   return true if answer == 'y'
  #   false
  # end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      determine_winner
      display_winner
      score.update(@winner)
      score.display(human.name, computer.name)
      break if score.winner_of_set
    end
    display_set_winner
    display_goodbye_message
  end
end

RPSgame.new.play
