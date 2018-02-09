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
  @@hangman.new_game
  session[:word] = @@hangman.word
  session[:message] = @@hangman.message
  session[:output] = @@hangman.output
  session[:used_letters] = @@hangman.used_letters
  session[:chances_left] = @@hangman.chances
  session[:end_message] = @@hangman.end_message
  session[:end_message_id] = @@hangman.end_message_id
  redirect '/play'
end 

get '/play' do 
  @word = session[:word]
  @letter = params['letter']
  @message = session[:message]
  @output = session[:output].join(' ')
  @used_letters = session[:used_letters].join(', ')
  @chances_left = session[:chances_left]
  @end_message = session[:end_message]
  @image = "images/#{@chances_left.to_s}.jpg"
  @end_message_id = session[:end_message_id]
  erb :index
  
end 

post '/play' do
 
  @letter = params['letter'].upcase
  #@@hangman.check_input(@letter)
  #@@hangman.end_game?
  
    if @letter == "" || !session[:end_message].empty?
     session[:message] = ""
    elsif @letter =~ /[^A-Z]/
      session[:message] = "Please type a letter"
    elsif session[:used_letters].join.include?(@letter)
      session[:message] = "You already tried that one"
    elsif session[:word].join.include?(@letter)
      session[:word].each_with_index do |l, i|
        session[:output][i] = l if @letter == l 
      end
      session[:message] = "Right!"
      session[:used_letters] << @letter 
    else 
      session[:message] = "Wrong!"
      session[:used_letters] << @letter 
      session[:chances_left] -= 1
    end 
    
    if session[:output].join == session[:word].join
      session[:end_message] = "Congratualtions, you won!"
      session[:end_message_id] = "won"
    
    elsif session[:chances_left] <= 0
      session[:end_message] = "Sorry, you lost. The word was \"#{session[:word].join}\""
      session[:end_message_id]="lost"
    end 
    
  @word = session[:word]
  @message = session[:message]
  @output = session[:output].join(' ')
  @used_letters = session[:used_letters].join(', ')
  @chances_left = session[:chances_left]
  @end_message = session[:end_message]
  @image = "images/#{@chances_left.to_s}.jpg"
  @end_message_id = session[:end_message_id]
  redirect '/play'
end 

get '/new_game' do
  redirect '/'
end 

@@hangman = Hangman.new 
