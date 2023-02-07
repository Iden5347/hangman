require 'json'

def get_guess(guesses)
  while true
    print "guess: "
    guess = gets.chomp.downcase
    if guess == "save"
      return "end"
    elsif guesses.include? guess or guess.length != 1 or guess.to_i.to_s == guess
      puts "invalid"
    else
      return guess
    end
  end
end

def save_game(guesses, wrong_guesses, secret_word)
  Dir.mkdir('saved') unless Dir.exists?('saved')
  filename = "saved/game_#{rand(100000)}.json"
  while File.exist?(filename)
    filename = "saved/game_#{rand(100000)}.json"
  end
  File.open(filename, 'w') do |file|
    file.puts "{\"guesses\": #{guesses}, \"wrong_guesses\": #{wrong_guesses}, \"word\": \"#{secret_word}\"}"
  end
end

print "new or saved: "
guess = gets.chomp.downcase

if guess == "saved"
  filename = "saved/" + gets.chomp.downcase
  while not File.exists?(filename)
    puts "does not exist"
    filename = "saved/" + gets.chomp.downcase
  end
  
  file = File.read(filename)
  data = JSON.parse(file)
  secret_word = data["word"]
  guesses = data["guesses"]
  wrong_guesses = data["wrong_guesses"]
  secret_word.split("").each do |letter|
    if guesses.include? letter
      print letter
    else
      print "_"
    end
  end
  puts "\n\n"
else
  words = []
  File.open("words.txt").each do |line|
    line.strip!
    if line.length >= 5 and line.length <= 12
      words.append(line)
    end
  end
  index = rand(words.length + 1)
  secret_word = words[index]
  guesses = []
  wrong_guesses = []
end

won = false

while wrong_guesses.length < 10 and not won  

  puts "past guesses: #{wrong_guesses.join(", ")}"
  
  guess = get_guess(guesses)
  if guess == "end"
    save_game(guesses, wrong_guesses, secret_word)
    puts "saved!"
    break
  end
  guesses.append(guess)
  if not secret_word.split("").include?(guess)
    wrong_guesses.append(guess)
  end
  won = true
  secret_word.split("").each do |letter|
    if guesses.include? letter
      print letter
    else
      won = false
      print "_"
    end
  end
  puts "\n\n"
end

if won
  puts "You won!"
elsif wrong_guesses.length == 10
  puts "You lost, word was #{secret_word}"
end