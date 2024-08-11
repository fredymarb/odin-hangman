require_relative "word"
require_relative "player"

class Game
  attr_reader :game_word
  attr_accessor :correct_guesses, :wrong_guesses
  def initialize
    # intitalize other classes
    @word_class = Word.new
    @player_class = Player.new

    # instance variables we'll actually use
    @game_word = @word_class.random_word
    @correct_guesses = @word_class.correct_guesses
    @wrong_guesses = @word_class.wrong_guesses
    @lives_left = 10

  end

  def play_round
    loop do
      answer = @player_class.player_input
      # puts "#{@correct_guesses.join}"

      self.update_game(answer)

      puts "#{@correct_guesses.join}"
      puts "Wrong guesses: #{@wrong_guesses.inspect}"
      puts "Lives left: #{@lives_left}\n "

      if self.game_over?
        self.game_over_text
        break
      end
    end
  end

  def game_over?
    @game_word == @correct_guesses.join || @lives_left.zero?
  end

  def game_over_text
    if @game_word == @correct_guesses.join
      puts ">>>   #{@correct_guesses.join}   <<<"
      puts "You have won the game"
      puts "Number of wrong guesses: #{@wrong_guesses.length}"
    else
      puts "You lose. You have no lives left"
      puts "The word was >>>  #{@game_word}  <<<"
    end
  end

  def update_game(answer)
    if @wrong_guesses.include?(answer) || @correct_guesses.include?(answer)
      puts "You've tried '#{answer}' already. Try again."
    elsif @game_word.include?(answer)
      @game_word.chars.each_with_index do |letter, index|
        @correct_guesses[index] = letter if answer == letter
      end
    else
      @wrong_guesses.push(answer)
      @lives_left -= 1
    end
  end
end

game = Game.new
puts game.play_round
