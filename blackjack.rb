def new_deck
  deck = []
  suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
  ranks = ['Ace','2','3','4','5','6','7','8','9','10','Jack','Queen','King']
  suits.each do |suit|
    ranks.each do |rank|
      deck.push([rank,suit])
    end
  end
  shuffle(deck)
end

def shuffle(deck)
  deck.shuffle!
end

def show_hand(player)
  player.each {|pair| print "#{pair[0]} of #{pair[1]}\n"}
end

def show_current_draw(player)
  a,b = player.last
  print "#{a} of #{b}\n"
end

def update_score_hand(player_score)
  # sub out face cards for numerical values
  player_score.map! do |item|
    if item == "Ace"; item = 11
    elsif item == "Jack"; item = 10
    elsif item == "Queen"; item = 10
    elsif item == "King"; item = 10
    else; item.to_i
    end
  end
end

def tally_score_hand(player_score)
  # return the sum of player_score
    player_score.inject(0){|memo,n| memo + n}
end

def deal(deck, player, player_score)
  # deal a card from the deck and place in players hand and value
  card = deck.shift
  player.push(card)
  player_score.push(card[0])
end

def welcome
  puts '-' * 50
  puts ' '* 15 + "Welcome to Blackjack"
  puts '-' * 50
  puts
  puts
end

def instructions
  puts "\tThe aim of the game is to beat the dealer."
  puts "\tIf the player/dealer gets a score of 21 they win the round."
  puts "\tIf both player and dealer score 21 the round is a draw."
  puts "\tAny score over 21 is an instant loss."
  puts "\tIf neither player gets 21, the closest score below 21 wins."
  puts "\tThe dealer must stick on 16"
  puts "\tThe dealer will get 1 card initially and the player gets 2"
  puts "\tThe player draws first, followed by the dealer."
end


purse = 20

welcome
instructions

puts "\n\n\t\tPress enter to begin"

#Game variables I need to reset
start = gets.chomp
charlie = []
charlie_score = []
dealer = []
dealer_score = []
deck = new_deck

loop do
  if purse <= 0
    puts "You are out of cash!"
    break
  end

  puts "\n\n\t\tYour cash balance is #{purse}"
  puts "\n\n\t\tEnter quit to cash out or enter to bet"
  quit = gets.chomp
  if quit == "quit"
    break
  end
  while true
    puts "\n\n\t\tPlace your bets..."
    print "bet> "
    bet = gets.chomp.to_i
    if bet >= 1 && bet <= purse
      purse -= bet
      break
    end
  end


  puts "DEALING..."
  sleep(2)
  puts "\nDealers first card..."
  deal(deck, dealer, dealer_score)
  show_hand(dealer)
  sleep(2)
  puts "\nPlayers first two cards..."
  deal(deck, charlie, charlie_score)
  deal(deck, charlie, charlie_score)
  show_hand(charlie)
  sleep(2)

  #PLAYER TURN
  player_drawing = true
  while player_drawing
    update_score_hand(charlie_score)
    score = tally_score_hand(charlie_score)
    print "\nHit on #{score}? (Y/N): > "
    ans = gets.chomp

    if ans.downcase == 'y'
      puts "\nDEALING..."
      sleep(2)
      deal(deck, charlie, charlie_score)
      print "\nPlayer draws..."
      show_current_draw(charlie)
      sleep(1)
      # puts "\nPlayers hand..."
      # show_hand(charlie)
      update_score_hand(charlie_score)
      score = tally_score_hand(charlie_score)

      if score == 21
        puts "\n#{score} BLACKJACK!"
        player_drawing = false
        sleep(4)
      elsif score > 21
        puts "\n#{score} BUST!"
        player_drawing = false
        sleep(4)
      end

    elsif ans.downcase =='n'
      player_drawing = false
    else
      puts "Invalid keypress - use 'Y' or 'N'"
    end
  end

  #DEALER TURN
  puts "\nDEALERS TURN..."
  sleep(2)
  update_score_hand(dealer_score)
  dscore = tally_score_hand(dealer_score)
  puts "\nDealers hand..."
  show_hand(dealer)
  sleep(2)

  dealer_drawing = true
  while dealer_drawing
    update_score_hand(dealer_score)
    dscore = tally_score_hand(dealer_score)

    if dscore > 21
      puts "\nDEALER ON #{dscore}, DEALER BUST!"
      dealer_drawing = false
      sleep(4)
    elsif dscore == 21
      puts "\n#{dscore} DEALER BLACKJACK!"
      dealer_drawing = false
      sleep(4)
    elsif dscore < 16
      puts "\nDEALER ON #{dscore}, DRAWING ANOTHER CARD..."
      sleep(2)
      deal(deck, dealer, dealer_score)
      print "\nDealer draws..."
      show_current_draw(dealer)
      sleep(2)
    else
      puts "\nDEALER STICKS ON #{dscore}"
      dealer_drawing = false
      sleep(2)
    end
  end


  puts "\nFinal scores..."

  sleep(2)

  print "\nPLAYER HAND:\n"
  show_hand(charlie)
  puts "SCORE: #{score}"
  print "\nDEALER HAND:\n"
  show_hand(dealer)
  puts "SCORE: #{dscore}"

  if score == 21 && dscore == 21
    puts "\nDRAW"
    purse += bet
  elsif score > 21
    puts "\nPLAYER LOSES"
  elsif dscore > 21 && score <=21
    puts "\nPLAYER WINS"
    purse += bet * 2
  elsif score > dscore && score <=21
    puts "\nPLAYER WINS"
    purse += bet * 2
  elsif score < dscore && score <=21
    puts "\nPLAYER LOSES"
  elsif score == dscore
    puts "\nDRAW"
    purse += bet
  end

end
