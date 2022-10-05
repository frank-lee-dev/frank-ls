require 'pry'
# Costants
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

# Methods
def prompt(string)
  puts "=> #{string}"
end

def random_choice(score_board)
  score_board.keys.sample
end

def joinor(arr, punc = ', ', conj = 'or')
  case arr.size
  when 0 then ''
  when 1 then "#{arr.first}"
  when 2 then arr.join(" #{conj} ")
  else
    arr[-1] = "#{conj} #{arr.last}"
    arr.join("#{punc}")
  end
end

# rubocop: disable Metrics/AbcSize
def display_board(brd, score)
  system 'clear'
  puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "First to 5 wins the set."
  puts "Current score:"
  puts "Player: #{score[:player]}"
  puts "Computer: #{score[:computer]}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
end
# rubocop: enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def place_piece!(brd, player, scores)
  if player == :player
    player_places_piece!(brd)
  elsif player == :computer
    computer_places_piece!(brd)
    display_board(brd, scores)
  end
end

def alternate_player(current_player)
  if current_player == :player
    current_player = :computer
  elsif current_player == :computer
    current_player = :player
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a position to place a piece: (#{joinor(empty_squares(brd))})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid option"
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  comp_choice = nil

  # offense first
  WINNING_LINES.each do |line|
    comp_choice = threat?(line, brd, COMPUTER_MARKER)
    break if comp_choice
  end

  # defense
  if !comp_choice
    WINNING_LINES.each do |line|
    comp_choice = threat?(line, brd, PLAYER_MARKER)
    break if comp_choice
    end
  end

  if !comp_choice
    comp_choice = mid_available?(brd)
  end

  if !comp_choice
    comp_choice = empty_squares(brd).sample
  end

  brd[comp_choice] = COMPUTER_MARKER
end

def threat?(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2
    brd.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
  end
end

def mid_available?(brd)
  return 5 if brd[5] == INITIAL_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def update_scoreboard(score, winner)
  score[winner.downcase.to_sym] +=1
end

# Main line of code
prompt "Welcome to the game of tic tac toe! ..."

loop do
  scores = {player: 0, computer: 0}

  loop do
    first_mover = random_choice(scores)
    current_player = first_mover
    prompt "#{first_mover} has been chosen as the first mover for this game!"
    sleep(1.5)

    board = initialize_board

    loop do
      display_board(board, scores)
      place_piece!(board, current_player, scores)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board, scores)

    if someone_won?(board)
      winner = detect_winner(board)
      prompt "#{winner} won this round!"
      sleep(1)
      update_scoreboard(scores, winner)
      display_board(board, scores)
    else
      prompt "It's a tie!"
    end
    
    game_set_message(scores)

    if scores[:player] >= 5
      prompt "You are the champion of tic tac toe! Congratulations!"
      break
    elsif scores[:computer] >= 5
      prompt "You let the computer beat you this set. Better luck next time!"
      break
    end
  end

  prompt 'Would you like to play another set? (y/n)'
  break if gets.chomp.downcase.start_with?('n')
end

prompt 'Thanks for playing tic tac toe. Goodbye!'
