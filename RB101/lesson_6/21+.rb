require 'pry'

FULL_DECK = [
  ['S', 'Ace'], ['S', '2'], ['S', '3'], ['S', '4'], ['S', '5'], ['S', '6'],
  ['S', '7'], ['S', '8'], ['S', '9'], ['S', '10'], ['S', 'Jack'],
  ['S', 'Queen'], ['S', 'King'], ['C', 'Ace'], ['C', '2'], ['C', '3'],
  ['C', '4'], ['C', '5'], ['C', '6'], ['C', '7'], ['C', '8'], ['C', '9'],
  ['C', '10'], ['C', 'Jack'], ['C', 'Queen'], ['C', 'King'], ['H', 'Ace'],
  ['H', '2'], ['H', '3'], ['H', '4'], ['H', '5'], ['H', '6'], ['H', '7'],
  ['H', '8'], ['H', '9'], ['H', '10'], ['H', 'Jack'], ['H', 'Queen'],
  ['H', 'King'], ['D', 'Ace'], ['D', '2'], ['D', '3'], ['D', '4'], ['D', '5'],
  ['D', '6'], ['D', '7'], ['D', '8'], ['D', '9'], ['D', '10'], ['D', 'Jack'],
  ['D', 'Queen'], ['D', 'King']
]

def initialize_game
  system 'clear'
  prompt <<-MSG
  Welcome to a game of Black Jack Lite!
  It's the game of Black Jack we all love,
  but without the complicated rules like "Split" or "Double down".
  You can either choose to stop after any round,
  or you can play until the cards run out. Your choice.

  Press enter to begin. Enjoy!
  
  MSG
  gets
end

def prompt(string)
  puts "=> #{string}"
end

def draw_card(current_deck)
  current_deck.delete(current_deck.sample)
end

def display_hands(player_hand, dealer_hand)
  prompt "Dealer has: #{dealer_hand[0][1]} and an unknown card"
  prompt "You have: #{player_hand[0][1]} and #{player_hand[1][1]}"
end

def face_card_converter(hand)
  hand.map! do |value|
    case value
    when 'Jack'
      10
    when 'Queen'
      10
    when 'King'
      10
    when 'Ace'
      11
    else
      value.to_i
    end
  end
end

def card_values(hand)
  hand.collect { |card| card[1] }
end

def card_number_string(hand)
  hand.collect { |card| card[1] }.join(", ")
end

def hit_or_stay(player_score)
  prompt "Your current count is #{player_score}. Hit or stay?"
  call = gets.chomp.downcase
  true if call.start_with?('h')
end

def hit(hand, deck, current_player)
  prompt "#{current_player} hits!"
  sleep(1.5)
  hand << draw_card(deck)
  prompt "#{current_player}'s hand is now #{card_number_string(hand)}."
  prompt "Count is #{calculate(hand)}"
  sleep(1.5)
  calculate(hand)
end

def stay(score, current_player)
  prompt "#{current_player} stayed at #{score}"
  sleep(1.5)
  score
end

def bust?(score)
  score > 21
end

def reveal_dealer_hand(dealer_hand)
  prompt "Dealer has #{card_number_string(dealer_hand)}."
  prompt "Count is #{calculate(dealer_hand)}"
end

def calculate(hand)
  values = card_values(hand)
  converted_values = face_card_converter(values).sum
  if converted_values > 21
    hand.select { |card| card == "Ace" }.count.times do
      converted_values -= 10
    end
  end
  converted_values
end

def dealer_play(hand, deck, current_player)
  if calculate(hand) > 16
    calculate(hand)
  else
    hit_until_win_or_bust(hand, deck, current_player)
  end
end

def hit_until_win_or_bust(hand, deck, current_player)
  until calculate(hand) > 16
    hit(hand, deck, current_player)
  end
  calculate(hand)
end

def display_final_hand(player_hand, dealer_hand)
  sleep(1.5)
  prompt "Dealer has #{card_number_string(dealer_hand)}."
  prompt "Dealer count is #{calculate(dealer_hand)}"
  sleep(1.5)
  prompt "Player has #{card_number_string(player_hand)}."
  prompt "Player count is #{calculate(player_hand)}"
  sleep(1.5)
end

def player_wins_msg(player_hand, dealer_hand)
  display_final_hand(player_hand, dealer_hand)
  prompt "Congratulations! You won this round!"
end

def dealer_wins_msg(player_hand, dealer_hand)
  display_final_hand(player_hand, dealer_hand)
  prompt "Looks like the house beat you this time. Better luck next time!"
end

initialize_game
deck = Marshal.load(Marshal.dump(FULL_DECK))

loop do
  system 'clear'

  player_hand = []
  dealer_hand = []
  player_score = 0
  dealer_score = 0
  current_player = 'Player'

  2.times do
  player_hand << draw_card(deck)
  dealer_hand << draw_card(deck)
  end

  display_hands(player_hand, dealer_hand)
  player_score = calculate(player_hand)

  loop do
    if hit_or_stay(player_score)
      player_score = hit(player_hand, deck, current_player)
    else
      stay(player_score, current_player)
      break
    end
    if bust?(player_score)
      prompt "It's a BUST! You lost. better luck next time."
      sleep(1.5)
      break
    end
  end

  loop do
    break if bust?(player_score)

    current_player = 'Dealer'
    reveal_dealer_hand(dealer_hand)
    dealer_score = dealer_play(dealer_hand, deck, current_player)
    if bust?(dealer_score)
      prompt 'Dealer busted! Congrats on the win!'
    elsif player_score == dealer_score
      sleep(1)
      prompt "It's a push."
    elsif player_score > dealer_score
      player_wins_msg(player_hand, dealer_hand)
    else
      dealer_wins_msg(player_hand, dealer_hand)
    end
    break
  end

  if deck.size <= 6
    prompt "The deck is finished!"
    break
  end

  prompt "Do you want to play another round?"
  prompt "You can play until the current deck runs out of cards!"
  prompt "#{deck.size} cards remaining. (y/n)"
  break if gets.chomp.downcase.start_with?('n')
end

prompt 'Thank you for playing Black Jack Lite! See you next time!'
