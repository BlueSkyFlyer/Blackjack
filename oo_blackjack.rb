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
    total > 21
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
end


class Dealer 
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end


# Engine

class Blackjack
	def initialize(deck, player, dealer)
		@deck = Deck.new 
		@player = Player.new
		@dealer = Dealer.new
	end

  def deal_cards
  	@deck.shuffle
  end

	def run
		deal_cards
		player_goes
		dealer_goes
		who_won?
		play_again?
	end
end

deck = Deck.new

player = Player.new('Jack')
player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.show_hand


dealer = Dealer.new
dealer.add_card(deck.deal_one)
dealer.add_card(deck.deal_one)
dealer.show_hand





