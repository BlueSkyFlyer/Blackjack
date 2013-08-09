
def calculate_total(cards) 
  # [['H', '3'], ['S'. 'Q'], ...]
  arr = cards.map{ |e| e[1] }

  total = 0
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

def game hit_or_stay

	if hit_or_stay == 1
		mycards << deck.pop
		calculate_total(mycards)
		puts "You now have #{mytotal}"
	elsif hit_or_stay == 2
    dealercards << deck.pop
    calculate_total(dealercards)
    puts "The dealer has #{dealertotal}"
  end
end

  	
			



puts "Let's play Blackjack! What's your name?"

name = gets.chomp

puts "Let's get started!"

suits = ['H', 'D', 'S', 'C']
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

deck = suits.product(cards)
deck.shuffle!

# Deal Cards

mycards = []
dealercards = []

mycards << deck.pop
dealercards << deck.pop
mycards << deck.pop
dealercards << deck.pop

dealertotal = calculate_total(dealercards)
mytotal = calculate_total(mycards)

# Show Cards

puts "Dealer has: #{dealercards[0]} and #{dealercards[1]}, for a total of #{dealertotal}"
puts "You have: #{mycards[0]} and #{mycards[1]} for a total of : #{mytotal}"
puts " "
puts "What would you like to do? 1) Hit 2) Stay"
hit_or_stay = gets.chomp

hit_or_stay.game

