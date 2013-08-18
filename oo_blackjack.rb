require 'rubygems'
require 'pry'

#1. Write out the detailed specs
#2. Extract out major nouns; these are your classes.
#3. Extract out major verbs; these are your behaviors/methods. 

# Card and Deck classes

class Card
	attr_accessor :suit, :face_value

  def initialize(s, fv)
  	@suit = s
  	@face_value = fv
  end

  def pretty_output
    "The #{face_value} of #{find_suit}"
  end

  def find_suit
  	case suit
  	  when 'H' then 'Hearts'
  	  when 'D' then 'Diamonds'
  	  when 'S' then 'Spades'
  	  when 'C' then 'Clubs'
  	end
  end

  def to_s
  	pretty_output
  end
end

class Deck
attr_accessor :cards

	@@count = 0

	def initialize
		@cards = []
		['H', 'D', 'S', 'C'].each do |suit|
			['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
				@cards << Card.new(suit, face_value)
			end
		end
		scramble!
    @@count += 1
	end

  def scramble!
  	cards.shuffle!
  end

  def deal_one
    cards.pop 
  end

  def size
  	cards.size
  end

  def self.total_decks
  	@@count
  end
end

# Make a new Hand

module Hand
	attr_accessor :cards, :total

	def initialize
		@total = 0
	end

	def total
  # [['H', '3'], ['S'. 'Q'], ...]
    face_values = @cards.map{ |card| card.face_value}

    total = 0
    face_values.each do |value|
      if value == "A"
    	  total += 11
      else
      	total += (value.to_i == 0 ? 10 : value.to_i)
    end

    # correct for aces

    face_values.select{ |value| value == "A" }.count.times do
        break if total <= 21
    	  total -= 10
      end
    end

    total
  end

  def show_hand
  	puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end

    puts "=> Total: #{total}"
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end

#  Player and Dealer methods


class Player 
  include Hand
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def show_flop
    show_hand
  end
end


class Dealer 
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end
end


# Engine

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("Player1")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack. #{player.name} loses."
      else
        puts "Congratulations, you hit blackjack! #{player.name} wins!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted. You win!"
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)
    while !player.is_busted?
      puts "What would you like to do? 1) Hit or 2) Stay"
      response = gets.chomp

      if !['1', '2'].include?(response)
        puts "Error: You must enter 1 or 2"
      next
      end

      if response == '2'
        puts "#{player.name} chose to stay."
        break
      end

      #Hit
      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"

      blackjack_or_bust?(player)
    end
  end

  def dealer_turn
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)

    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}"

      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total
      puts "Congratulations, #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses."
    else
      puts "Push!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1) Yes 2) No"
    if gets.chomp == '1'
      puts "Starting a new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Goodbye!"
      exit
    end
  end


  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start

