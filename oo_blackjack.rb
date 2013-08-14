require 'rubygems'
require 'pry'

#1. Write out the detailed specs
#2. Extract out major nouns; these are your classes.
#3. Extract out major verbs; these are your behaviors/methods. 

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

  def show_cards # Not correct/ not working
  	"Deck: #{@cards}"
  end

  def self.total_decks
  	@@count
  end
end


class Player
  attr_accessor :hand, :value

  def initialize
  	@hand = []
  	@value = 0
  end


end


class Dealer
	attr_accessor :hand, :value

	def initialize
		@hand = []
		@value = 0
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

c1 = Card.new('H', '3')
c2 = Card.new('D', '4')

c1.pretty_output
c2.pretty_output

deck = Deck.new
binding.pry

