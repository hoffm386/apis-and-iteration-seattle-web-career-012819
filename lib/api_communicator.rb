require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character_name)
  film_list = []

  #make the web request
  response_string = RestClient.get('http://www.swapi.co/api/people/')
  response_hash = JSON.parse(response_string)

  # iterate over the response hash to find the collection of `films` for the given
  #   `character`
  results = response_hash["results"]
  if results
    character = results.find {|result| result["name"] == character_name}
    if character
      films = character["films"]
      if films
        # collect those film API urls, make a web request to each URL to get the info
        #  for that film
        film_list = films.map do |film|
          film_response_string = RestClient.get(film)
          # return value of this method should be collection of info about each film.
          #  i.e. an array of hashes in which each hash reps a given film
          # this collection will be the argument given to `print_movies`
          #  and that method will do some nice presentation stuff like puts out a list
          #  of movies by title. Have a play around with the puts with other info about a given film.
          film_response_hash = JSON.parse(film_response_string)
        end
      end
    end
  end

  film_list
end

def print_movies(films)
  films.each do |film|
    puts film["title"]
    puts "Episode #{film["episode"]}"
    puts film["release_date"]
    puts
  end
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
