require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ').to_a
    attempt = @word.upcase.split('').to_a

    parsing = {}
    url = 'https://wagon-dictionary.herokuapp.com/'

    if (attempt.map do |l|
      @letters.include?(l) && @letters.count(l) >= attempt.count(l)
      end).all?
      parsing = JSON.parse(open("#{url}#{@word}").read)
    else
      parsing[:false_letter] = true
    end

    if parsing[:false_letter]
      @message = 'The given word is not in the grid!'
    elsif parsing['found'] == false
      @message = "That's not an english word!"
    else
      @message = "Great, your score is #{parsing["word"].size * 10}"
    end
  end
end
