require 'rails_helper'
require 'rspec/rails'

describe MoviesController, :type => :controller do
  
  describe 'Search movies with the same director' do
    
    it 'finds the movie with the given id' do
      given_movie = double("Movie_1", title: 'Star Wars', director: 'George Lucas')
      expect(Movie).to receive(:find).with("1").and_return(given_movie) 
      get :search_similar_movies, params: {id:1}
    end
      
    it 'calls the model method that performs the search' do
      given_movie = double("Movie_1", title: 'Star Wars', director: 'George Lucas')
      allow(Movie).to receive(:find).with("1").and_return(given_movie)
      expect(Movie).to receive(:similar_movies).with(given_movie)
      get :search_similar_movies, params: {id:1}
    end
    
    it 'selects the Similar Movies template for rendering' do
      given_movie = double("Movie_1", title: 'Star Wars', director: 'George Lucas')
      allow(Movie).to receive(:find).with("1").and_return(given_movie)
      allow(Movie).to receive(:similar_movies).with(given_movie)
      get :search_similar_movies, params: {id:1}
      expect(response).to render_template('search_similar_movies')
    end
      
    it 'makes the search results available to that template' do
      given_movie = double("Movie_1", title: 'Star Wars', director: 'George Lucas')
      allow(Movie).to receive(:find).with("1").and_return(given_movie)
      @fake_results = [double(Movie), double(Movie)]
      allow(Movie).to receive(:similar_movies).with(given_movie).and_return(@fake_results)
      get :search_similar_movies, params: {id:1}
      expect(response).to render_template('search_similar_movies')
      expect(assigns(:movies)).to eq(@fake_results)
    end
    
    it 'redirects to movies_path with warning' do
      given_movie = double("Movie_1", title: 'Star Wars', director: '')
      expect(Movie).to receive(:find).with("1").and_return(given_movie)
      get :search_similar_movies, params: {id:1}
      expect(flash[:warning]).to eq "'#{given_movie.title}' has no director info"
      expect(response).to redirect_to(movies_path)
    end
  end
end
