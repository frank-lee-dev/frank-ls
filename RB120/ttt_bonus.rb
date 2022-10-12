require 'pry'

module Formattable
  def clear
    system 'clear'
  end

  def joinor(arr, punctuation_mark = ',', join_word = 'or')
    case arr.size
    when 1 then arr.first
    when 2 then arr.join(" #{join_word} ")
    else
      arr[-1] = "#{join_word} #{arr.last}"
      arr.join("#{punctuation_mark} ")
    end
  end

  def margin
    puts "-" * 35
  end

  def pause
    sleep(2)
  end
end

module Displayable
  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won this round!"
    when computer.marker
      puts "You lost this round!"
    else
      puts "It's a tie!"
    end
    pause
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_set_winner
    clear_screen_and_display_board
    if board.winning_marker == human.marker
      puts "You won the set! Congrats champ!"
    else
      puts "Looks like you weren't so lucky this time.. Do better!"
    end
  end

  def display_score_board
    margin
    puts "   #{display_human_score}   |   #{display_computer_score}"
    margin
    puts " First to win #{TTTgame::PLAY_UPTO} games is the champ!"
    margin
  end

  def display_human_score
    "#{human.name}: #{scores[human]}"
  end

  def display_computer_score
    "#{computer.name}: #{scores[computer]}"
  end

  def display_board
    display_score_board
    puts "You (#{human.name}) are #{human.marker}."
    puts "#{computer.name} is #{computer.marker}."
    puts
    board.draw
    puts
  end

  def display_welcome_message
    clear
    puts "Welcome to the game of tic tac toe!"
    puts "Connect three of your markers to win the round."
    puts "First to win #{TTTgame::PLAY_UPTO} is the ultimate winner."
    puts
    puts "Press 'enter' to begin!"
    gets
  end

  def display_goodbye_message
    puts "Thanks for playing! Let's play again soon!"
  end

  def display_play_again_message
    puts "Let's play again!"
  end
end

module AI
  def random_marker_placement
    board[board.available_squares.sample] = computer.marker
  end

  def block_threat
    block_at = board.squares.select do |k, v|
      threat_line.first.any?(k) && v.marker == Board::INITIAL_MARKER
    end.keys.first

    board[block_at] = computer.marker
  end

  def threat_line
    Board::WINNING_LINES.select do |line|
      line_marker = board.squares.values_at(*line).collect(&:marker)

      (line_marker.count(human.marker) == 2) &&
        (line_marker.count(Board::INITIAL_MARKER) == 1)
    end
  end

  def threat?
    !threat_line.empty?
  end

  def take_the_opportunity
    opportunity_square = board.squares.select do |k, v|
      opportunity_line.first.any?(k) && v.marker == Board::INITIAL_MARKER
    end.keys.first

    board[opportunity_square] = computer.marker
  end

  def opportunity_line
    Board::WINNING_LINES.select do |line|
      line_marker = board.squares.values_at(*line).collect(&:marker)

      (line_marker.count(computer.marker) == 2) &&
        (line_marker.count(Board::INITIAL_MARKER) == 1)
    end
  end

  def opportunity_for_attack?
    !opportunity_line.empty?
  end

  def open_center_square?
    board.squares[5].marker == Board::INITIAL_MARKER
  end

  def take_center_square
    board.squares[5].marker = computer.marker
  end
end

class Board
  INITIAL_MARKER = ' '
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    squares[num].marker = marker
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def available_squares
    squares.select { |_, v| v.marker == INITIAL_MARKER }.keys
  end

  def full?
    available_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_same_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |num| squares[num] = Square.new(INITIAL_MARKER) }
  end

  private

  def three_same_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def marked?
    marker != Board::INITIAL_MARKER
  end

  def to_s
    marker
  end
end

class Player
  attr_accessor :marker, :name

  def initialize
    @marker = nil
    @name = nil
  end
end

class TTTgame
  PLAY_UPTO = 3

  def play
    display_welcome_message
    initial_setup
    main_game
    display_goodbye_message
  end

  private

  COMPUTER_MARKERS = %w(O X 5 U 0 B R T M)
  COMPUTER_NAMES = %w(WALL-E R2D2 C3PO ULTRON)
  include Formattable, Displayable, AI

  attr_reader :board, :human, :computer, :scores, :first_to_move

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    @first_to_move = nil
    @current_marker = nil
    @scores = { human => 0, computer => 0 }
  end

  def initial_setup
    set_name
    set_marker
    clear
    set_first_mover
  end

  def main_game
    loop do
      play_set
      break unless play_again?
      reset
      reset_score
      display_play_again_message
    end
  end

  def set_name
    clear
    puts "Enter your user name for this game:"
    human.name = gets.chomp

    computer.name = (COMPUTER_NAMES - [human.name]).sample
    clear
  end

  def set_marker
    answer = nil

    loop do
      puts "Enter the marker you'd like to use for this game."
      puts "It can be any character, but it must be 1 character only."
      answer = gets.chomp
      break unless answer.length > 1 || answer.empty?
      puts "The character must be 1 letter. Try again."
    end

    human.marker = answer

    computer.marker = (COMPUTER_MARKERS - [human.marker]).sample
  end

  def set_first_mover
    answer = nil

    loop do
      puts 'Would you like to choose the first mover for this set? (y/n)'
      puts '(If yes, you will choose who goes first. If not, computer will.)'
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry it must be 'y' or 'n'."
    end

    answer == 'y' ? human_chooses_first_mover : computer_chooses_first_mover
    @current_marker = first_to_move
  end

  def human_chooses_first_mover
    answer = nil

    loop do
      puts "Would you like to go first? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry it must be 'y' or 'n'."
    end

    @first_to_move = (answer == "y" ? human.marker : computer.marker)
  end

  def computer_chooses_first_mover
    @first_to_move = [human.marker, computer.marker].sample
  end

  def play_set
    loop do
      play_round
      break if set_winner?
      reset
    end
    display_set_winner
  end

  def play_round
    clear_screen_and_display_board
    player_moves
    display_result
    update_scoreboard
  end

  def update_scoreboard
    case board.winning_marker
    when human.marker then scores[human] += 1
    when computer.marker then scores[computer] += 1
    end
  end

  def set_winner?
    scores[human] == PLAY_UPTO || scores[computer] == PLAY_UPTO
  end

  def player_moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def human_moves
    square = nil

    puts "Choose a square from the following available squares"
    puts "Available squares: #{joinor(board.available_squares)}"
    loop do
      square = gets.chomp.to_i
      break if (board.available_squares).include?(square)
      puts "That's not a valid choice. Enter a value between 1 through 9."
    end

    board[square] = human.marker
  end

  def computer_moves
    if opportunity_for_attack?
      take_the_opportunity
    elsif threat?
      block_threat
    elsif open_center_square?
      take_center_square
    else
      random_marker_placement
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry it must be 'y' or 'n'."
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = first_to_move
    clear
  end

  def reset_score
    @scores[human] = 0
    @scores[computer] = 0
  end

  def current_player_moves
    human_turn? ? human_moves : computer_moves
    switch_players
  end

  def switch_players
    @current_marker = human_turn? ? computer.marker : human.marker
  end

  def human_turn?
    @current_marker == human.marker
  end
end

game = TTTgame.new
game.play
