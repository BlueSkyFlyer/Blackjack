
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

# Start Game

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


# Player turn

if mytotal == 21
  puts "Congratulations, you hit blackjack! You win!"
  exit
end

while mytotal < 21
	puts "What would you like to do? 1) Hit 2) Stay"
  hit_or_stay = gets.chomp

  if !['1', '2'].include?(hit_or_stay)
    puts "Error: you must enter 1 or 2"
    next
  end

  # Stay
  
  if hit_or_stay == "2"
  	puts "You chose to stay."
    break
  end

  # Hit
  new_card = deck.pop
  puts "Dealing card to player: #{new_card}"
  mycards << new_card
  mytotal = calculate_total(mycards)
  puts "Your total is now: #{mytotal}"

  if mytotal == 21
  	puts "Congratulations, you hit blackjack! You win!"
  	exit
  elsif mytotal > 21
  	puts "Sorry - it looks like you busted!" 
  	exit
  end
end

# Dealer turn

if dealertotal == 21
	puts "Sorry, dealer hit blackjack. You lose"
	exit
end

while dealertotal < 17
	# Hit
	new_card = deck.pop
	puts "Dealing new card for dealer: #{new_card}"
	dealercards << new_card
	dealertotal = calculate_total(dealercards)
	puts "Dealer total is now: #{dealertotal}"

  if dealertotal == 21
  	puts "Sorry, dealer hit blackjack. You lose."
  	exit
  elsif dealertotal > 21
  	puts "Congratulations, dealer busted! You win!"
  	exit
  end
end

# Compare hands

puts "Dealer's cards: "
dealercards.each do |card|
	puts "=> #{card}"
end

puts "Your cards: "
mycards.each do |card|
	puts "=> #{card}"
end
puts

if dealertotal > mytotal
	puts "Sorry, dealer won."
elsif dealertotal < mytotal
	puts "Congratulations, you win!"
else
	puts "It's a tie!"
end

exit


