VALID_CHOICES = %w(rock paper scissors lizard spock)
POWER_DYNAMICS = { rock: ['scissors', 'lizard'],
                   paper: ['rock', 'spock'],
                   scissors: ['paper', 'lizard'],
                   lizard: ['paper', 'spock'],
                   spock: ['rock', 'scissors'] }

# Methods

def prompt(message)
  puts "=> #{message}"
end

def welcome_message
  prompt(`clear`)
  prompt <<-MSG
  Welcome to the game of rock, paper, scissor, lizard, spock!
  Here are the rules:
  1) Scissors cuts paper and decapitates lizard
  2) Rock crushes scissors and lizard
  3) Paper covers rock and disproves Spock
  4) Lizard poisons Spock and eats paper
  5) Spock smashes scissors and vaporizes rock
  
  You will play until either you or the computer has won three rounds.
  
  MSG

  gets
end

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

def get_player_choice
  prompt("Choose one: #{VALID_CHOICES.join(', ')}")
  prompt("You can also use, 'r' 'p' 'sc' 'l' 'sp' as a shortcut")
  gets.chomp.downcase
end

def valid_choice?(player_choice)
  VALID_CHOICES.include?(player_choice)
end

def invalid_choice_message
  prompt("That's not a valid choice.")
end

def display_choices(player_choice, computer_choice)
  prompt("You chose: #{player_choice}; Computer chose: #{computer_choice}")
end

def win?(first, second)
  POWER_DYNAMICS[first.to_sym].include?(second)
end

def get_results(player_choice, computer_choice)
  if win?(player_choice, computer_choice) then :player
  elsif win?(computer_choice, player_choice) then :computer
  else :tie
  end
end

def display_results(result)
  sleep(2)
  if result == :player
    prompt('You won!')
  elsif result == :computer
    prompt('You lost!')
  else
    prompt("It's a tie!")
  end
end

def update_scoreboard(winner, score_board)
  score_board[winner] += 1
end

def display_scoreboard(score_board)
  sleep(2)
  prompt("Your score: #{score_board[:player]}")
  prompt("Computer score:#{score_board[:computer]}")
end

def next_round_message
  sleep(2)
  prompt('Time for the next round.')
  sleep(2)
  prompt('Ready?')
  sleep(2)
  prompt(`clear`)
end

def winner?(score_board)
  if score_board[:player] == 3 || score_board[:computer] == 3
    true
  end
end

def set_completion_message(score_board)
  if score_board[:player] == 3
    prompt "Congrats on winning this set!"
  else
    prompt "Better luck next time!"
  end
end

def play_again
  prompt('Do you want to play again?')
  answer = gets.chomp
  answer.downcase.start_with?("y")
end

def reset(score_board)
  score_board[:player] = 0
  score_board[:computer] = 0
  score_board[:tie] = 0
end

def start_over_message
  prompt('Starting your next round...')
  sleep(1.5)
  prompt(`clear`)
end

def goodbye_message
  prompt('Thank you for playing rock, paper, scissors, lizard, Spock. Goodbye!')
end

# Main body of program

welcome_message
score_board = { player: 0, computer: 0, tie: 0 }

loop do
  loop do
    player_choice = ''
    loop do
      player_choice = shortcut(get_player_choice)
      break if valid_choice?(player_choice)
      invalid_choice_message
    end

    computer_choice = VALID_CHOICES.sample
    display_choices(player_choice, computer_choice)
    match_result = get_results(player_choice, computer_choice)
    display_results(match_result)
    update_scoreboard(match_result, score_board)
    display_scoreboard(score_board)
    winner?(score_board) ? break : next_round_message
  end

  set_completion_message(score_board)
  play_again ? reset(score_board) : break
  start_over_message
end

goodbye_message
