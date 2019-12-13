require 'pry'

class Marble

  attr_accessor :number, :next_marble, :prev_marble

  def initialize(number:, next_marble: nil, prev_marble: nil)
    @number = number
    @next_marble = next_marble
    @prev_marble = prev_marble
  end

  def insert_next(marble)
    #temp holding
    next_marble = @next_marble
    #connect insert
    @next_marble = marble
    #new next connect with old next
    marble.next_marble = next_marble
    #new next connect
    marble.prev_marble = self
  end

end

binding.pry
def simulate_marble_game(n_players, n_last_marble)

  # first marble, marble0, is a circle all by itself!
  current_marble = Marble.new(number: 0)
  current_marble.next_marble = current_marble
  current_marble.prev_marble = current_marble

  players = {}
  n_players.times {|n| players[n] = 0 }

  n_last_marble.times do |m|

    # .times start at 0, therefore the marble to be placed is off by 1
    real_marble_num = m + 1
    if real_marble_num % 23 == 0
      7.times{ current_marble = current_marble.prev_marble }

    else
      new_marble = Marble.new(number: real_marble_num)
      current_marble.insert_next(new_marble)
    end

  end

  puts "Players: #{players}"
  puts ""
end
