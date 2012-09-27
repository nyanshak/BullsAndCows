require 'socket'  

def generate_word(len)
	srand
	([1, 2, 3, 4, 5, 6, 7, 8, 9].shuffle)[0,len].join("")
end
 
def score(word, guess)
end

port = 9004
ss = TCPServer.new(port)
puts "Server Started >"
loop {
	Thread.start(ss.accept) { |s|
		begin
			clientPort, clientIP = Socket.unpack_sockaddr_in(s.getpeername)
			input = "again"
			while (input.chomp.casecmp("exit") != 0)
				s.puts "Cows and Bulls: 1) New Game 2) Rules 3) Exit"
				input = s.gets
				puts "Client at #{clientIP}:#{clientPort}> #{input}"
				case input.chomp
				when "new game", "1"
					word_length = -1
					while !(word_length < 7 && word_length > 2)  ## not between 3 and 6
						s.puts "How many digits should we use for this game? (3-6):"
						word_length = Integer(s.gets)
						if !(word_length < 7 && word_length > 2)
							s.puts "#{word_length} is not between 3 and 6. Try again"
							s.gets
						end
					end
					s.puts "I have chosen a number with #{word_length} unique digits from 0 to 9."
					s.gets
					word = generate_word(word_length)
					puts "Answer for client at #{clientIP}:#{clientPort} is #{word}";
					count = 0
					while true
						guess = "999"
						while true
							s.puts "Enter a guess: "
							guess = s.gets.strip
							puts "Client at #{clientIP}:#{clientPort} guessed: #{guess}"
							err = nil
							case
								when guess.match(/\D/)
									err = "digits only"
								when guess.length != word_length
									err = "exactly #{word_length} digits"
								when guess.split("").uniq.length != word_length
									err = "digits must be unique "
								else 
									err = nil
								end
							break if err.nil?
							s.puts "The word must be #{word_length} unique digits between 1 and 9 (#{err}).  Try again."
							s.gets
						end
						count += 1
						break if word == guess
						####
						bulls = cows = 0

						guess2 = guess + ''
						word2 = word + ''

						guess2.scan(/[0-9]/).each_with_index do |char, index|
							break if index == word2.size
							if char == word2[index, 1]
								guess2[index, 1] = word2[index, 1] = "."
								bulls += 1
							end
						end

						guess2.scan(/[0-9]/).each do |char|
							if index = word2.index(char)
								word2[index, 1] = "."
								cows += 1
							end
						end


						##
						s.puts "that guess has #{bulls} bulls and #{cows} cows"
						s.gets
					end
					s.puts "You guessed correctly in #{count} tries."
					puts "Client at #{clientIP}:#{clientPort} guessed correctly in #{count} tries."
					s.gets
					s.puts "    "
					s.gets
				when "rules", "2"
					s.puts "A number (3 to 6 digits [0-9]) is chosen by me. You try to guess the number."
					s.gets
					s.puts " "
					s.gets
					s.puts "I will tell you how many bulls and how many cows."
					s.gets
					s.puts " "
					s.gets
					s.puts "1 Bull = 1 number correct value, correct position"
					s.gets
					s.puts " "
					s.gets
					s.puts "1 Cow = 1 number correct value, incorrect position"
					s.gets
					s.puts " "
					s.gets
					s.puts "Example: 4271 (secret number) -> You guess 1234 (1 bull, 2 cows).  The number of guesses for you to win is your score."
					s.gets
				when "exit", "3"
					input = "exit"
					s.puts "Goodbye"
				else
					s.puts "Invalid input. Choices are: 1) New Game 2) Rules 3) Exit"
				end	
			end
		rescue
			bt = $!.backtrace * "\n  "
			if !/ECONNABORTED|chomp/.match($!.inspect)
				($stderr << "error: #{$!.inspect}\n  #{bt}\n").flush
			end
		ensure
			s.close
		end
	}
}
