require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

class Hangman
  attr_accessor :word, :output, :used_letters, :chances, :message, :end_game, :end_message
  def initialize
    @dictionary = File.readlines('5desk.txt')
    @dictionary.select! {|w| w.chomp.length > 4 && w.chomp.length < 13}
    @word = @dictionary.sample.chomp.upcase.split('')
    @output = Array.new(word.size, "_")
    @used_letters = []
    @message = "" 
    @chances = 6
    @end_game = false
    @end_message = ""
  end
  def select_word
     @word = @dictionary.sample.chomp.upcase.split('')
  end 
  def check_input(input)
    return if input == nil
    input = input.upcase
    if input == "" || @end_game
      @message = ""
    elsif input =~ /[^A-Z]/
      @message = "Please type a letter"
    elsif @used_letters.join.include?(input)
      @message = "You already tried that one"
    elsif @word.join.include?(input)
      @word.each_with_index do |l, i|
        output[i] = l if input == l 
      end
      @message = "Right"
      @used_letters << input 
    else 
      @message = "Wrong"
      @used_letters << input 
      @chances -= 1
    end 
  end 

  def end_game?
    if @output.join == @word.join
      @end_message = "Congratualtions, you won!"
      @end_game = true 
    elsif @chances <= 0
      @end_message = "Sorry, you lost. The word was \"#{@word.join}\""
      @end_game = true
    else
      @end_game = false 
    end 
  end 

end




get '/' do 

  @letter = params['letter']
  @message = @@hangman.message
  @output = @@hangman.output.join(' ')
  @used_letters = @@hangman.used_letters.join(', ')
  @chances_left = @@hangman.chances
  @end_message = @@hangman.end_message
  erb :index
  
end 

post '/' do
  @letter = params['letter']
  @message = @@hangman.message
  @output = @@hangman.output.join(' ')
  @used_letters = @@hangman.used_letters.join(', ')
  @chances_left = @@hangman.chances
  @end_message = @@hangman.end_message
  @@hangman.check_input(@letter)
  @@hangman.end_game?
  redirect '/'
end 




@@hangman = Hangman.new 
@@word = @@hangman.word
