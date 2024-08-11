class Word
  attr_reader :random_word
  attr_accessor :correct_guesses, :wrong_guesses

  def initialize
    @list_of_words = fetch_file_contents("dictionary.txt")
    @random_word = generate_word
    @correct_guesses = Array.new(@random_word.length, "_")
    @wrong_guesses = []
  end

  private

  def fetch_file_contents(filename)
    words_array = []
    file = File.readlines(filename)

    file.each do |word|
      word.strip!
      words_array.push(word.downcase)
    end

    words_array.compact.uniq
  end

  def generate_word
    new_word = nil

    loop do
      new_word = nil
      new_word = @list_of_words.sample

      break if new_word.length.between?(7, 12)
    end
    new_word
  end
end
