module Formattable
  def clear_screen
    system 'clear'
  end

  def double_margin
    puts "=" * 25
  end

  def single_margin
    puts '-' * 25
  end

  def pause
    sleep(2)
  end
end

module Displayable
  def display_full_hand_image
    puts '+---+' + (' +---+' * (hand.size - 1))
    puts center_of_card
    puts '+---+' + (' +---+' * (hand.size - 1))
  end

  def display_half_hand_image
    puts '+---+' + (' +---+' * (hand.size - 1))
    puts center_of_card_half_hand
    puts '+---+' + (' +---+' * (hand.size - 1))
  end

  def display_out_of_cards_message
    clear_screen
    puts 'It looks like we went through most of the deck.'
    puts 'Launch the game again if you would like to play again.'
    puts
    pause
  end

  def display_full_hand
    clear_screen
    double_margin
    puts 'Dealer hand'
    dealer.display_full_hand_image
    single_margin
    puts 'Player hand'
    player.display_full_hand_image
    double_margin
  end

  def display_result
    display_full_hand
    puts "You got #{player.calculate_total}."
    puts "Dealer got #{dealer.calculate_total}."
    pause
    display_winner
  end

  def display_winner
    if player.calculate_total > dealer.calculate_total
      puts "You won!"
    elsif player.calculate_total < dealer.calculate_total
      puts "You lost!"
    else
      puts "Push. It's a tie!"
    end
  end

  def display_dealer_bust_message
    puts "Dealer busted with a #{dealer.calculate_total}! You win!"
  end

  def display_player_bust_message
    puts "#{player.calculate_total} is a BUST! Dealer wins!"
    pause
  end

  def display_total
    puts "You have a total of #{player.calculate_total}."
  end

  def display_hands
    clear_screen
    double_margin
    puts 'Dealer hand'
    dealer.display_half_hand_image
    single_margin
    puts 'Player hand'
    player.display_full_hand_image
    double_margin
  end

  def display_welcome_message
    clear_screen
    puts <<-MSG
    Welcome to a game of Black Jack Lite!
    It's the game of Black Jack we all love,
    but without the complicated rules like "Split" or "Double down".
    You can either choose to stop after any round,
    or you can play until the cards run out. Your choice.
  
    Press enter to begin. Enjoy!
    
    MSG
    gets
  end

  def display_goodbye_message
    puts "Thank for playing Black Jack Lite! I hope you enjoyed it!"
  end

  def display_play_screen
    clear_screen
    display_hands
    display_total
  end
end

class Participants
  include Formattable, Displayable

  attr_reader :hand

  def initialize
    @hand = []
    @ace_in_hand = 0
  end

  def calculate_total
    total = hand.map { |card| card_converter(card) }.sum
    total -= 10 * hand.count("Ace") if total > 21
    total
  end

  def hit(card)
    hand << card
  end

  def bust?
    calculate_total > 21
  end

  def empty_hands
    @hand = []
  end

  private

  def center_of_card
    center_line = []

    hand.size.times do |num|
      center_line << if hand[num - 1] == '10'
                       "| #{hand[num - 1]}|"
                     else
                       "| #{hand[num - 1].chr} |"
                     end
    end

    center_line.reverse.join(' ')
  end

  def center_of_card_half_hand
    hand.last == '10' ? "| ? | | #{hand.last}|" : "| ? | | #{hand.last.chr} |"
  end

  def card_converter(card)
    case card
    when "Jack" then 10
    when "Queen" then 10
    when "King" then 10
    when "Ace" then 11
    else card.to_i
    end
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = {
      spade: %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King),
      club: %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King),
      heart: %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King),
      diamond: %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)
    }
  end

  def deal_card
    random_suit = @cards.select { |_, v| !v.empty? }.keys.sample
    random_card = @cards[random_suit].sample
    remove_card(random_card, random_suit)
    random_card
  end

  def not_enough_cards?
    cards.values.flatten.count < 10
  end

  private

  attr_writer :cards

  def remove_card(card, suit)
    cards[suit].delete(card)
  end
end

class TwentyOneGame
  def initialize
    @player = Participants.new
    @dealer = Participants.new
    @deck = Deck.new
  end

  def play
    display_welcome_message
    core_game
    display_goodbye_message
  end

  private

  include Formattable, Displayable
  attr_reader :deck
  attr_accessor :player, :dealer

  def core_game
    loop do
      play_hand
      display_result if !player.bust? && !dealer.bust?
      play_again? ? reset_hands : break
      if deck.not_enough_cards?
        display_out_of_cards_message
        break
      end
    end
  end

  def play_hand
    deal_hands
    display_hands
    participants_play
  end

  def participants_play
    player_plays
    if player.bust?
      display_player_bust_message
      pause
    else
      reveal_dealer_card
      dealer_plays
      display_dealer_bust_message if dealer.bust?
    end
  end

  def reset_hands
    player.empty_hands
    dealer.empty_hands
  end

  def deal_hands
    2.times do
      player.hand << deck.deal_card
      dealer.hand << deck.deal_card
    end
  end

  def dealer_plays
    loop do
      display_full_hand
      break if dealer.bust?
      if dealer.calculate_total < 17
        dealer_hits
      else
        dealer_stays
        break
      end
    end
  end

  def dealer_hits
    puts "Dealer has #{dealer.calculate_total}"
    dealer.hit(deck.deal_card)
    pause
    puts "Dealer hits #{dealer.hand.last}!"
    pause
  end

  def dealer_stays
    puts "Dealer has #{dealer.calculate_total}. Dealer stays."
    pause
  end

  def reveal_dealer_card
    clear_screen
    display_full_hand
    pause
    puts "Dealer revealed a #{dealer.hand.first}!"
    pause
  end

  def player_plays
    loop do
      display_play_screen
      break if player.bust?
      if hit?
        player_hits
      else
        player_stays
        break
      end
    end
  end

  def player_hits
    player.hit(deck.deal_card)
    puts "You hit #{player.hand.last}!"
    pause
  end

  def player_stays
    puts "Player stays with a #{player.calculate_total}."
    pause
  end

  def hit?
    answer = nil

    loop do
      puts 'Do you want to hit (get another card) or stay?'
      puts "(You can type 'h' to hit or 's' to stay)"
      answer = gets.chomp.downcase.slice(0)
      break if %w(h s).any?(answer)
      puts "That's not a valid answer. Either type 'h' to hit or 's' to stay."
    end

    answer == 'h'
  end

  def play_again?
    puts "Would you like to continue playing? (y/n)"
    answer = nil

    loop do
      answer = gets.chomp.downcase
      break if answer == 'y' || answer == 'n'
      puts "Invalid input. Enter either 'y' for 'yes' or 'n' for 'no'"
    end

    answer == 'y'
  end
end

game = TwentyOneGame.new
game.play
