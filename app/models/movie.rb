class Movie < ActiveRecord::Base

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_all_by_same_director(id)
    director = Movie.find(id).director
    director.nil? ? nil : Movie.find_all_by_director(director)
  end
end



