require 'spec_helper'

describe Movie do
    describe 'finding movies directed by same director' do

   context 'valid director for a movie' do
      it 'should return movies' do
        fake_movie = mock('Movie', :id => "1", :title => "Star Wars", :director => "George Lucas") 
	Movie.should_receive(:find).with(1).and_return(fake_movie)
	Movie.should_receive(:find_all_by_director).with(fake_movie.director)
        Movie.find_all_by_same_director(1)
      end
   end

  context 'invalid director for a movie' do
      it 'should return empty list' do
        fake_movie = mock('Movie', :id => "3", :title => "Alien", :director => nil) 
	Movie.stub(:find).with(3).and_return(fake_movie)
	Movie.stub(:find_all_by_director).with(fake_movie.director)
        Movie.find_all_by_same_director(3).should be_nil
      end
   end

 end
end
