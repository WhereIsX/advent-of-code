require 'pry'

module MarblesMania

  Player = Struct.new(
    :number,
    :score,
    keyword_init: true)

  def run_simulation(num_players, last_marble)
    marbles = [0,2,1]
    current = 1
    players = {}
    num_players.times do |num|
      players[num+1] = Player.new(
                          number: num+1,
                          score: 0)
    end

    marble_num = 3

    while marble_num != last_marble

      next_pos = find_next_pos(current, marbles.length)

      if special_marble?(marble_num)
        player_to_gain_points = players[find_player_turn(marble_num, num_players)]

        points = marble_num + marbles[current-7]
        player_to_gain_points.score += points

        # puts players.sort_by{|n, p| p.score}
        # binding.pry

        marbles.delete(current-7)
        current -= 6
        marble_num +=1
      else
        # binding.pry
        marbles.insert(next_pos, marble_num)
        current = next_pos
        marble_num += 1
      end

      # p marbles
      # sleep(0.5)
      # binding.pry
    end

    p players.collect{|n, p| p.score}.sort
  end

  def find_next_pos(current, length)
    next_pos = current + 2
    next_pos -= length if next_pos > length
    next_pos
  end

  def special_marble?(marble_num)
    marble_num % 23 == 0
  end

  def find_player_turn(marble_num, num_players)
    player = marble_num % num_players
    player = num_players if player == 0
    player
  end

end
