class Player
  def player_input
    confirm_options = %w[quit exit restart]

    loop do
      print "Enter a letter: "
      response = ask_input
      response.downcase!

      return response if response.match?(/[a-z]/) && response.length == 1
      return response if confirm_options.include?(response)

      puts "Enter a single letter(a-z)\n "
    end
  end

  def confirm_new_game
    confirm_options = %w[y yes n no]

    loop do
      print "Do you want to start new game?[Y/n]: "
      response = ask_input
      response.downcase!

      return response if confirm_options.include?(response)

      puts "Enter y for yes and n for no\n "
    end
  end

  def play_or_load
    confirm_options = %w[0 1]

    loop do
      puts "[0]: play new game"
      puts "[1]: load saved game"
      response = ask_input

      return response if confirm_options.include?(response)

      puts "Enter 0 or 1\n "
    end
  end

  def confirm_quit
    confirm_options = %w[y yes n no]

    loop do
      print "Do you want to save game before quiting?[Y/n]: "
      response = ask_input
      response.downcase!

      return response if confirm_options.include?(response)

      puts "Enter y for yes and n for no\n "
    end
  end

  private

  def ask_input
    gets.chomp
  end
end
