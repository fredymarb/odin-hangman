class Player
  def player_input
    response = nil

    loop do
      print "Enter a letter: "
      response = ask_input
      response.downcase!

      return response if response.match?(/[a-z]/) && response.length == 1

      puts "Enter a single letter(a-z)\n "
    end
  end

  def play_or_load
    response = nil
    loop do
      puts "[0]: play new game"
      puts "[1]: load saved game"
      response = self.ask_input

      return response if response == "0" || response == "1"

      puts "Enter 0 or 1\n "
    end
  end

  private

  def ask_input
    gets.chomp
  end
end
