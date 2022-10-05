RPS_HANDS = %w(rock paper scissors lizard spock)
PLAY_UPTO = 3

class Score
  attr_accessor :human_score, :computer_score, :round_number

  def initialize
    @human_score = 0
    @computer_score = 0
    @round_number = 0
  end

  def update(winner)
    if winner.class == Human
      self.human_score += 1
    elsif winner.class == Computer
      self.computer_score += 1
    end

    self.round_number += 1
  end

  def display(human_name, computer_name)
    system 'clear'
    puts "-" * 30
    puts " Score Board | #{human_name} : #{self.human_score}"
    puts "             | #{computer_name} : #{self.computer_score}"
    puts
    puts " First to win #{PLAY_UPTO} is the winner!"
    puts "-" * 30
  end

  def reset
    self.human_score = 0
    self.computer_score = 0
    self.round_number = 0
  end

  def winner_of_set
    if self.human_score == PLAY_UPTO
      "Congratulations! You won!"
    elsif self.computer_score == PLAY_UPTO
      "Aww looks like you weren't lucky this around. Better luck next time!"
    else
      false
    end
  end
end

class History
  attr_accessor :log

  def initialize
    set_log
  end

  def set_log
    self.log = []
  end

  def update(choice)
    log << choice
  end

  def line_break
    puts "-" * 30
  end

  def round_history(round_number, comp_history)
    0.upto(round_number - 1) do |round_num|
      line_break
      puts "rd.#{round_num + 1} | Player  : #{log[round_num]}"
      puts "     | Computer: #{comp_history[round_num]}"
    end
  end

  def display(round_number, comp_history)
    return if round_number == 0
    line_break
    puts (" " * 10) + "History log"
    round_history(round_number, comp_history)
    line_break
  end
end

class Player
  attr_accessor :choice, :history

  def initialize
    @choice = nil
    @history = History.new
  end

  # enables shortcuts for chortcute keys
  def shortcut(input)
    case input
    when 'r' then input << 'ock'
    when 'sc' then input << 'issors'
    when 'p' then input << 'aper'
    when 'l' then input << 'izard'
    when 'sp' then input << 'ock'
    else input
    end
  end

  def make_move(choice)
    case choice.downcase
    when 'rock'     then Rock.new
    when 'paper'    then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard'   then Lizard.new
    when 'spock'    then Spock.new
    end
  end
end

class Human < Player
  attr_accessor :name

  def initialize
    set_name
    super
  end

  def set_name
    system 'clear'
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
      puts "Make your choice: rock, paper, scissors, lizard, or spock"
      puts "(You can also use 'r', 'p', 'sc', 'l', 'sp' as shortcuts!)"
      answer = shortcut(gets.downcase.chomp)
      break if RPS_HANDS.include?(answer)
      puts "That's an invalid choice."
    end

    self.choice = make_move(answer)
  end
end

# This module is the AI engine for computer. Depending on computer name,
# it chooses a hand preset that are limited in form
module SmartPlayable
  OCKY = ['rock', 'spock']
  THIN_HANDS = ['paper']
  BALL_DOM = ['rock', 'rock', 'rock', 'scissors']
  CURIOUS = ['paper', 'lizard', 'lizard']

  def generate_hand(comp_name)
    case comp_name
    when 'R2D2'   then OCKY
    when 'C3PO'   then THIN_HANDS
    when 'WALL-E' then CURIOUS
    when 'KAWHII' then BALL_DOM
    else RPS_HANDS
    end
  end
end

class Computer < Player
  attr_accessor :name

  include SmartPlayable

  def initialize
    set_name
    super
  end

  def set_name
    self.name = ["R2D2", "C3PO", "WALL-E", "KAWHII"].sample
  end

  def choose
    self.choice = make_move(generate_hand(name).sample)
  end
end

class Move
  attr_reader :beats, :move

  def >(other_value)
    beats.include?(other_value)
  end
end

class Rock < Move
  def initialize
    @move = 'rock'
    @beats = ['scissors', 'lizard']
  end
end

class Paper < Move
  def initialize
    @move = 'paper'
    @beats = ['rock', 'spock']
  end
end

class Scissors < Move
  def initialize
    @move = 'scissors'
    @beats = ['paper', 'lizard']
  end
end

class Lizard < Move
  def initialize
    @move = 'lizard'
    @beats = ['paper', 'spock']
  end
end

class Spock < Move
  def initialize
    @move = 'spock'
    @beats = ['rock', 'scissors']
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

  def momentary_pause
    sleep(2.5)
  end

  # rubocop:disable Metrics/MethodLength
  def display_welcome_message
    system('clear')
    puts <<-MSG
    Welcome to the game of rock, paper, scissor, lizard, spock!
    Here are the rules:
    1) Scissors cuts paper and decapitates lizard
    2) Rock crushes scissors and lizard
    3) Paper covers rock and disproves Spock
    4) Lizard poisons Spock and eats paper
    5) Spock smashes scissors and vaporizes rock
    
    You will play until either you or the computer has won #{PLAY_UPTO} rounds.
    Press enter to start the game!
    MSG
    gets
  end
  # rubocop:enable Metrics/MethodLength

  def display_goodbye_message
    puts "Thanks for playing, #{human.name}! See you again."
  end

  def display_moves
    puts "#{human.name} chose #{human.choice.move}"
    puts "#{computer.name} chose #{computer.choice.move}."
  end

  def determine_winner
    @winner = if human.choice.move > computer.choice.move
                human
              elsif computer.choice.move > human.choice.move
                computer
              else
                "tie"
              end

    momentary_pause
  end

  def display_winner
    if @winner == human
      puts "#{human.name} won!"
    elsif @winner == computer
      puts "#{computer.name} won.."
    else
      puts "It's a tie!"
    end
    puts
  end

  def display_set_winner
    if @winner == human
      puts "Congrats #{human.name}! You're ultimate winner of this set, champ!"
    else
      puts "Looks like #{computer.name} got you this set."
      puts "Better luck next time!"
    end
  end

  def display_header
    score.display(human.name, computer.name)
    human.history.display(score.round_number, computer.history.log)
  end

  def play_again?
    puts "Would you like to play another set? (y/n)"
    answer = nil

    loop do
      answer = gets.chomp.downcase
      break if answer == 'y' || answer == 'n'
      puts "Invalid input. Enter either 'y' for 'yes' or 'n' for 'no'"
    end

    return true if answer == 'y'
    false
  end

  def play_round
    human.choose
    human.history.update(human.choice.move)
    computer.choose
    computer.history.update(computer.choice.move)
    display_moves
    determine_winner
  end

  def play_set
    loop do
      display_header
      play_round
      display_winner
      score.update(@winner)
      break if score.winner_of_set
    end
  end

  def play
    display_welcome_message
    loop do
      play_set
      display_set_winner
      play_again? ? score.reset : break
    end
    display_goodbye_message
  end
end

RPSgame.new.play
