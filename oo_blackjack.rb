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
  	puts "The #{face_value} of #{find_suit}"
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
		@cards = []
	end

	def calculate_total
  # [['H', '3'], ['S'. 'Q'], ...]
    arr = @cards.map{ |e| e[1] }

    arr.each do |value|
      if value == "A"
    	  total += 11
      elsif value.to_i == 0 # J, Q, K
    	  total += 10
      else
      	total += value.to_i
      end
    end

    # correct for aces

    arr.select{ |e| e == "A" }.count.times do
      if total > 21
    	  total -= 10
      end
    end

    total
  end

  def cards
  	@cards
  end
end

# Person, Player, and Dealer methods

class Person
	include Hand
	attr_accessor :name

	def initialize(name)
		@name = name
		@hand = Hand.new
	end
end

class Player < Person

  def hit

  end

  def stay

  end
end


class Dealer < Person

	def hit

	end

	def stay

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
Jack = Player.new('Jack')
Sam = Dealer.new('Sam')





