class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      
      if (params[:sort].nil? && !session[:sort].nil?) ||
         (params[:ratings].nil? && !session[:ratings].nil?)
        flash.keep
        if params[:sort].nil? && !params[:ratings].nil?
          redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
        elsif params[:ratings].nil? && !params[:sort].nil?
          redirect_to movies_path(:sort => params[:sort], :ratings => session[:ratings])
        else
          redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
        end
      end
      
      @ratings_to_show = params[:ratings]
      if @ratings_to_show.nil?
        @ratings_to_show = @all_ratings
        @all_ratings = Hash[@all_ratings.collect {|r| [r, true]}]
      else
        @all_ratings = Hash[@all_ratings.collect {|r| [r, false]}]
        @ratings_to_show = @ratings_to_show.keys
        @ratings_to_show.each do |key|
          @all_ratings[key] = true
        end
      end
      
      @movies = Movie.with_ratings(@ratings_to_show, params[:sort])
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end