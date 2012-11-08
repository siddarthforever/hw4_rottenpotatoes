require 'spec_helper'

describe MoviesController do
  
  describe 'Find Movies With Same Director' do
  
    it 'should use a RESTful route for "find similar movies"' do
      assert_routing({ :method => 'get', :path => 'movies/1/similar' }, { :controller => "movies", :action => "similar", :id => "1" })
    end
    
    it 'should call the model method that performs finding movies with same director' do
      m=mock('Movie',:title=>'Rambo-2', :id => 1)
      Movie.stub(:find).with("1").and_return(m)
      Movie.should_receive(:find_all_by_same_director).with("1")
      get :similar, :id => "1"
    end
    
    it 'should select the Show Similar Movies template for rendering' do
      mock_results = [mock('Movie')]
      Movie.stub(:find_all_by_same_director).and_return(mock_results)
      get :similar, :id => "1"
      response.should render_template("similar")
    end

   it 'should make the results available to that template' do
      mock_results = [mock('Movie')]
      Movie.stub(:find_all_by_same_director).and_return(mock_results)
      get :similar, :id => "1"
      assigns(:movies_with_same_director).should == mock_results
    end

   it 'should select the homepage template for rendering empty results' do
        m=mock('Movie',:title=>'Rambo', :id => 3)
        Movie.stub(:find).with("3").and_return(m)
       	Movie.stub(:find_all_by_same_director).and_return(nil)
        get :similar, :id => "3"
        response.should redirect_to(:action => 'index')
        flash[:notice].should eql("'Rambo' has no director info.")
   end

  end

end
