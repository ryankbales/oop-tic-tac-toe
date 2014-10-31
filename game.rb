module FreshBoard
  def refresh_board_spots
    spots = {}
    i = 1
    (1..9).each do |pos|
      spots[pos] = i
      i += 1
    end
    spots
  end
end

module CheckForWinner
  def there_is_a_win_or_draw(current_set, player_1, player_2, outcome)
    current_set.each do |a|
      if a.uniq.length == 1 #If all items are the same
        if a.first == player_1
          outcome = player_1.upcase
          return outcome
        else
          outcome = player_2.upcase
          return outcome
        end
      end
    end
    #if there isn't a winner than we need to keep going or it's a draw
    #keep going?
    current_set.each do |a|
      if  (a.uniq.length > 1) && (a.all? {|spot| (spot.is_a? String) || (spot.is_a? Integer) })
        outcome = "Pick again!"
        return outcome
      end
    end
    #then it must be a tie
    current_set.each do |a|
      if  (a.uniq.length > 1) && (a.all? {|spot| spot.is_a? String}) #if they aren't the same and all strings it's a tie
        outcome = "It's a draw!"
        return outcome
      end
    end
  end
end

class Player
  attr_accessor :name, :mark

  def initialize(name, mark="")
    @name = name
    @mark = mark
  end

  def assign_mark(marks) #pass and array with X and O as it's only elements
    if marks.count == 2 #bascially, if there are two marks in the array, the human player hasn't selected.
      puts "Do you want to be 'X' or 'O'"
      response = gets.chomp.upcase
      self.mark = response
      marks.delete_if {|m| m == response }
    else
      self.mark = marks.include?("O") ? "O" : "X"
    end
  end
end

class Board
  include FreshBoard

  attr_accessor :spots

  def initialize
    @spots = self.refresh_board_spots
  end

  def draw_board(status)
    system 'clear'
    puts "The Tic Tac Toe Board"
    puts "====================="
    puts ""
    puts " #{spots[1]} | #{spots[2]} | #{spots[3]} | "
    puts "-------------"
    puts " #{spots[4]} | #{spots[5]} | #{spots[6]} | "
    puts "-------------"
    puts " #{spots[7]} | #{spots[8]} | #{spots[9]} | "
    puts status
  end
end

class Game
  include CheckForWinner
  def initialize
    puts "Let's play tic tac toe!"
  end
  def play
    marks = ["X", "O"] #Establish the pieces
    puts "What's your first name?"
    name = gets.chomp.capitalize #Get the human players name
    human = Player.new(name)
    machine = Player.new("McApple")  #Assign the computer a name
    human.assign_mark(marks)
    machine.assign_mark(marks)
    board = Board.new

    play_status = true
    set_status = "Choose Wisely"
    winning_sets = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

    while play_status
      board.draw_board(set_status)
      spots = board.spots
      puts "#{human.name}, mark your spot!(1-9)" # get human input
      spot = gets.chomp.to_i

      #assign to board and replace number in winning_set
      spots[spot] = human.mark
      winning_sets = winning_sets.map { |i| i.map { |mark| (mark == spot) ? human.mark : mark} }

      #computer figures out available spots
      available_spots = spots.select { |k, v|  v.is_a?(Integer)  }
      available_spots_value = []
      available_spots.each do |k, v|
        available_spots_value << v
      end

      machine_choice = available_spots_value.shuffle.first

      spots[machine_choice] = machine.mark
      winning_sets = winning_sets.map { |i| i.map { |mark| (mark == machine_choice) ? machine.mark : mark} }

      set_status = there_is_a_win_or_draw(winning_sets, human.mark, machine.mark, set_status)
      unless set_status == "Pick again!"
        if set_status == human.mark
          puts "#{human.name} wins!"
        elsif set_status == machine.mark
          puts "#{machine.name} wins!"
        elsif set_status == "It's a draw!"
          puts set_status
        end
        puts "#{human.name}, would you like to play again? Enter yes or no?"
        answer = gets.chomp.downcase
        if answer == "yes"
          play_satus = true
          #reset the array's to original form and refresh the board
          winning_sets = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
          board = Board.new
        else
          play_staus = false
        end
      end
    end
  end
end

game = Game.new
game.play
