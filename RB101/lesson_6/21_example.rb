require 'yaml'
MESSAGES = YAML.load_file('twenty_one_messages.yml')

CARD_VALUES = {
  "2" => 2,
  "3" => 3,
  "4" => 4,
  "5" => 5,
  "6" => 6,
  "7" => 7,
  "8" => 8,
  "9" => 9,
  "10" => 10,
  "Jack" => 10,
  "Queen" => 10,
  "King" => 10,
  "Ace" => 11
}

VALID_INPUTS = ['hit', 'stay', 'h', 's']

VALID_FORFEITS = ['y', 'n', 'yes', 'no']

GAMES_TO_WIN = 5

BUST_LIMIT = 21

DEALER_STAY_THRESHOLD = BUST_LIMIT - 4

SLEEP_DURATION = 1.5

def welcome
  system('clear')
  message('welcome')
  wait_for_input
end

def message(yaml_key)
  prompt MESSAGES[yaml_key]
end

def prompt(msg)
  puts "=> #{msg}"
end

def wait_for_input
  gets
end

def initialize_deck
  deck = Hash.new
  CARD_VALUES.each_key do |k|
    deck[k] = 4
  end

  deck
end

def deal_opening_hands!(deck, player_hand, dealer_hand)
  2.times do
    deal_card!(deck, player_hand)
    deal_card!(deck, dealer_hand)
  end
end

def deal_card!(deck, hand)
  card = draw_card_from_deck!(deck)
  hand[0] << card
  hand[1] << CARD_VALUES[card]
end

def draw_card_from_deck!(deck)
  card = deck.filter { |_, v| v > 0 }.keys.sample
  deck[card] -= 1
  card
end

def determine_score(values)
  values = values.clone.sort
  score = values.reduce(:+)

  loop do
    if bust?(score) && ace?(values)
      convert_ace_to_one!(values)
      score = values.reduce(:+)
    else
      break
    end
  end

  score
end

def bust?(number)
  number > BUST_LIMIT
end

def ace?(values)
  values.include?(11)
end

def convert_ace_to_one!(values)
  values.sort!.pop
  values.prepend(1)
end

def display_whose_turn(person)
  system('clear')
  prompt "#{person}'s turn!"
  pause
end

def pause
  sleep SLEEP_DURATION
end

def display_hands(p_hand, d_hand, score, wins, hide_dealer_card=true)
  system('clear')

  if hide_dealer_card
    d_hand = [[d_hand[0].first, 'an unknown card']]
    d_score = 'unknown'
  else
    d_score = score[:dealer]
  end

  prompt "GAME WINS: You: #{wins[:player]}  Dealer: #{wins[:dealer]}"
  prompt "Dealer has #{joinand(d_hand[0])}. Total: #{d_score}."
  prompt "You have #{joinand(p_hand[0])}. Total: #{score[:player]}."
  pause
end

def joinand(array, delimiter=", ", final_delim='and')
  cloned_array = array.clone

  if array.size < 3
    cloned_array.join(" #{final_delim} ")
  else
    cloned_array[-1] = "#{final_delim} #{array[-1]}"
    cloned_array.join(delimiter)
  end
end

def get_string_input(string_prompt, valid_inputs)
  loop do
    prompt string_prompt
    user_input = gets.chomp.strip.downcase

    return user_input if valid_inputs.include?(user_input)

    message('invalid_choice')
  end
end

def hit(deck, person, hand, score)
  deal_card!(deck, hand)
  display_last_card(hand)
  score[person] = determine_score(hand[1])
end

def display_last_card(hand)
  last_card = hand[0].last
  prompt "#{preposition(last_card)} #{last_card} was dealt."
  pause
end

def preposition(card)
  if card == "8" || card == "Ace"
    'An'
  else
    'A'
  end
end

def stay?(answer)
  answer.start_with?('s')
end

def display_game_result(player_hand, dealer_hand, score, wins)
  game_status = determine_status(score)

  display_hands(player_hand, dealer_hand, score, wins, false)

  case game_status
  when :player_bust then message('player_bust')
  when :dealer_bust then message('dealer_bust')
  when :player_win then message('player_win')
  when :dealer_win then message('dealer_win')
  when :tie then message('tie')
  end
end

def determine_status(score)
  if bust?(score[:player]) then :player_bust
  elsif bust?(score[:dealer]) then :dealer_bust
  elsif score[:player] > score[:dealer] then :player_win
  elsif score[:dealer] > score[:player] then :dealer_win
  else :tie
  end
end

def update_wins!(score, wins)
  game_status = determine_status(score)

  case game_status
  when :player_bust then wins[:dealer] += 1
  when :dealer_bust then wins[:player] += 1
  when :player_win then wins[:player] += 1
  when :dealer_win then wins[:dealer] += 1
  end
end

def game_over?(wins)
  five_wins?(wins) || forfeit?
end

def five_wins?(wins)
  wins.value?(5)
end

def forfeit?
  answer = get_string_input(MESSAGES['forfeit?'], VALID_FORFEITS)
  answer.start_with?('y')
end

def display_final_score(wins)
  system('clear')
  prompt "GAME WINS: You: #{wins[:player]}  Dealer: #{wins[:dealer]}"

  if wins[:player] == 5
    message('player_won_5_games')
  elsif wins[:dealer] == 5
    message('dealer_won_5_games')
  else
    message('forfeit')
  end
end

welcome

wins = {
  player: 0,
  dealer: 0
}

loop do
  deck = initialize_deck
  player_cards = []
  player_values = []
  dealer_cards = []
  dealer_values = []
  player_hand = [player_cards, player_values]
  dealer_hand = [dealer_cards, dealer_values]

  deal_opening_hands!(deck, player_hand, dealer_hand)

  score = {
    player: determine_score(player_values),
    dealer: determine_score(dealer_values)
  }

  display_whose_turn("Player")

  until bust?(score[:player])
    display_hands(player_hand, dealer_hand, score, wins)
    answer = get_string_input(MESSAGES['hit_or_stay?'], VALID_INPUTS)
    if answer.start_with?('h')
      message('player_hit')
      hit(deck, :player, player_hand, score)
    end
    break if stay?(answer)
  end

  if bust?(score[:player])
    display_game_result(player_hand, dealer_hand, score, wins)
    update_wins!(score, wins)
    game_over?(wins) ? break : next
  end

  message('player_stayed')
  pause

  display_whose_turn("Dealer")

  until score[:dealer] >= DEALER_STAY_THRESHOLD
    display_hands(player_hand, dealer_hand, score, wins, false)
    message('dealer_hit')
    hit(deck, :dealer, dealer_hand, score)
  end

  if bust?(score[:dealer])
    display_game_result(player_hand, dealer_hand, score, wins)
    update_wins!(score, wins)
    game_over?(wins) ? break : next
  end

  display_hands(player_hand, dealer_hand, score, wins, false)
  message('dealer_stay')
  pause

  display_game_result(player_hand, dealer_hand, score, wins)
  update_wins!(score, wins)

  break if game_over?(wins)
end

display_final_score(wins)