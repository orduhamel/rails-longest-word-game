require "open-uri"

class GamesController < ApplicationController
  def new
    # create a new @letters instance variable storing these random letters from the alphabet.
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    # recuperer le mot/input utilisateur
    @word = params[:word].upcase
    @letters = params[:letters]

    # The @word is built out of the original grid @letters
    if included?(@word, @letters)
      if english_word?(@word)
        # The word is valid according to the grid and is an English word
        @response = "Congratulations! #{@word} is a valid English word!"
      else
        # The word is valid according to the grid, but is not a valid English word
        @response = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      # The word cannot be built out of the original grid @letters
      @response = "Sorry but #{@word} cannot be built out of #{@letters}"
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found'] # => true or false
  end
end
