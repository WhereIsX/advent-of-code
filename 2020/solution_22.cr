require "./input_22.cr"

example_input = "
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
"

def parse(text)
  text.split("\n\n").map do |player|
    player.split(":\n").last.split("\n", remove_empty: true).map(&.to_i)
  end
end

def solve_part_one(text)
  player_one, player_two = parse(text)
  player_one = Deque.new(player_one)
  player_two = Deque.new(player_two)

  until game_over?(player_one, player_two)
    # draw both players cards
    player_one_card, player_two_card = draw_cards(player_one, player_two)
    # compare both players cards to determine winner
    # move cards to winners deck
    play_cards(player_one_card, player_two_card, player_one, player_two)
  end
  winner = crown_champion(player_one, player_two)

  scoreboard(winner)
end

def play_cards(player_one_card, player_two_card, player_one_deck, player_two_deck)
  # cards are garunteed to be unique, no ties
  if player_one_card > player_two_card
    player_one_deck.push(player_one_card)
    player_one_deck.push(player_two_card)
  else # player_two_card > player_one_card
    player_two_deck.push(player_two_card)
    player_two_deck.push(player_one_card)
  end
end

def draw_cards(player_one, player_two)
  Tuple.new(player_one.shift, player_two.shift)
end

def game_over?(player_one, player_two)
  player_one.empty? || player_two.empty? 
end

def scoreboard(deck)
  deck.reverse_each.map_with_index(1) do |card, index|
    card * index
  end.sum
end

def crown_champion(player_one, player_two)
  if player_one.empty?
    return player_two
  else #player_two.empty?
    return player_one
  end
end

p! solve_part_one(INPUT)