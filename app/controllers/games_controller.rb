require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    if valid_word?(@word, @letters)
      if english_word?(@word)
        @score = compute_score(@word)
        @message = "Well Done!"
      else
        @score = 0
        @message = "Not an English word."
      end
    else
      @score = 0
      @message = "Word can't be built out of the grid."
    end
  end

  def valid_word?(word, letters)
    word.chars.all? { |letter| letters.count(letter) >= word.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end

  def compute_score(word)
    word.length * 10
  end
end
