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

  end

  def play_round
    loop do
      answer = @player_class.player_input
      # puts "#{@correct_guesses.join}"

      update_game(answer)

      puts "#{@correct_guesses.join}"
      puts "Wrong guesses: #{@wrong_guesses.inspect}\n "

      break if @game_word == @correct_guesses.join
    end
  end

  def update_game(answer)
    if @game_word.include?(answer)
      @game_word.chars.each_with_index do |letter, index|
        @correct_guesses[index] = letter if answer == letter
      end
    else
      @wrong_guesses.push(answer)
    end
  end
end

game = Game.new
puts game.play_round
