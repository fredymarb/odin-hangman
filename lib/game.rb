require "yaml"
require_relative "word"
require_relative "player"
require "rubocop"
require "rubocop-performance"

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

  def play
    answer = @player_class.play_or_load
    if answer == "0"
      play_round
    else
      load_previous_game
    end
  end

  def load_previous_game
    puts "Ability to play saved previous game comming soon"
  end

  def play_round
    quit_options = %w[quit exit]

    loop do
      answer = @player_class.player_input

      if quit_options.include?(answer)
        quit_game
        break
      end

      update_game(answer)
      update_game_text

      return game_over_text if game_over?
    end
  end

  def to_yaml
    YAML.dump({
                game_word: @game_word,
                correct_guesses: @correct_guesses,
                wrong_guesses: @wrong_guesses,
                lives_left: @lives_left
              })
  end

  def self.from_yaml(string)
    data = YAML.load(string)
    new(data[:game_word], data[:correct_guesses], data[:wrong_guesses], data[:lives_left])
  end

  private

  def game_over?
    @game_word == @correct_guesses.join || @lives_left.zero?
  end

  def update_game_text
    puts @correct_guesses.join
    puts "Wrong guesses: #{@wrong_guesses.inspect}"
    puts "Lives left: #{@lives_left}\n "
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

  def quit_game
    confirm_yes = %w[y yes]
    confirm_no = %w[n no]

    confirm_quit = @player_class.confirm_quit
    if confirm_yes.include?(confirm_quit)
      puts to_yaml
      puts "Saving game...\n "
      puts "Quiting game...\n "
    elsif confirm_no.include?(confirm_quit)
      puts "Quiting game...\n "
    end
  end
end

game = Game.new
game.play
