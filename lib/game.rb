require_relative "word"
require_relative "player"
require "yaml"
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
      load_saved_game
      clear_saved_game
    end
  end

  def play_round
    quit_options = %w[quit exit]

    puts "Word is #{@game_word.length} letters long"
    update_game_text

    loop do
      answer = @player_class.player_input

      return quit_game if quit_options.include?(answer)

      update_game(answer)
      update_game_text
      return game_over_text if game_over?
    end
  end

  def load_saved_game
    play_round unless load_game.nil?
  end

  def clear_saved_game
    File.write("save_file.yaml", "")
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
    YAML.load(string)
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
      save_game(to_yaml)
      puts "Quiting game...\n "
    elsif confirm_no.include?(confirm_quit)
      puts "Quiting game...\n "
    end
  end

  def save_game(string)
    puts "Saving game... "
    File.write("save_file.yaml", string)
    puts "Game saved successfully... "
  end

  def load_game
    puts "loading saved game..."
    saved_game = File.read("save_file.yaml")

    if File.empty?("save_file.yaml")
      puts "You don't have any saved game yet."
      return nil
    end

    unserealized = Game.from_yaml(saved_game)

    @game_word = unserealized[:game_word]
    @correct_guesses = unserealized[:correct_guesses]
    @wrong_guesses = unserealized[:wrong_guesses]
    @lives_left = unserealized[:lives_left]
  end
end

game = Game.new
game.play
