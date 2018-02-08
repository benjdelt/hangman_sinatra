
class Hangman
  attr_accessor :word, :output, :used_letters
  def initialize
    @dictionary = File.readlines('5desk.txt')
    @dictionary.select! {|w| w.chomp.length > 4 && w.chomp.length < 13}
    @word = @dictionary.sample.chomp.upcase.split('')
    @output = Array.new(word.size, "_")
    @used_letters = []
    @message = "" 
  end
  def check_input(input)
    input = input.upcase
    unless input =~ /[A-Z]/
      @message = "Please input a letter"
    end 
  end 
  def check_letter(letter)
    
  end 
  def end_game?
    
  end 

end


=begin
game = Hangman.new
puts "HANGMAN"
puts "The computer has picked a word. Try and guess it!"
puts game.output.join(' ')
until game.end_game?(game.output, game.word, game.used_letters) 
  game.check_letter(game.input(game.used_letters, game.output), game.output, game.word, game.used_letters)
end
=end 
