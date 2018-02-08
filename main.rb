require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

class Hangman
  attr_accessor :word, :output, :used_letters, :chances, :message, :end_game, :end_message, :end_message_id
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
    @end_message_id = ""
  end
  def new_game
    @word = @dictionary.sample.chomp.upcase.split('')
    @output = Array.new(word.size, "_")
    @used_letters = []
    @message = "" 
    @chances = 6
    @end_game = false
    @end_message = ""
    @end_message_id = ""
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
      @message = "Right!"
      @used_letters << input 
    else 
      @message = "Wrong!"
      @used_letters << input 
      @chances -= 1
    end 
  end 

  def end_game?
    if @output.join == @word.join
      @end_message = "Congratualtions, you won!"
      @end_message_id = "won"
      @end_game = true 
    elsif @chances <= 0
      @end_message = "Sorry, you lost. The word was \"#{@word.join}\""
      @end_message_id="lost"
      @end_game = true
    else
      @end_game = false 
    end 
  end 

end

get '/' do 
  #@word = @@hangman.word
  @letter = params['letter']
  @message = @@hangman.message
  @output = @@hangman.output.join(' ')
  @used_letters = @@hangman.used_letters.join(', ')
  @chances_left = @@hangman.chances
  @end_message = @@hangman.end_message
  @image = "images/#{@chances_left.to_s}.jpg"
  @end_message_id = @@hangman.end_message_id
  erb :index
  
end 

post '/' do
  #@word = @@hangman.word
  @letter = params['letter']
  @message = @@hangman.message
  @output = @@hangman.output.join(' ')
  @used_letters = @@hangman.used_letters.join(', ')
  @chances_left = @@hangman.chances
  @end_message = @@hangman.end_message
  @image = "images/#{@chances_left.to_s}.jpg"
  @end_message_id = @@hangman.end_message_id
  @@hangman.check_input(@letter)
  @@hangman.end_game?
  redirect '/'
end 

get '/new_game' do
  @@hangman.new_game
  redirect '/'
end 

@@hangman = Hangman.new 

