class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Array.new
    Movie.select(:rating).uniq.each do |r|
      @all_ratings.push r.rating
    end

    if params[:ratings]!=nil
      session[:ratings] = params[:ratings]
    else
      if session[:ratings]==nil
        params[:ratings] = Hash.new
        @all_ratings.each do |x|
          params[:ratings][x] = 1
        end
      else 
        params[:ratings]=session[:ratings]
      end
      redirect_to movies_path(params)
    end
        
    
    if params[:sort]==nil
      params[:sort] = session[:sort]
    else
      session[:sort] = params[:sort]
    end
    
    
    @title = params[:sort] == "title"  ?  "hilite":"";
    @date =  params[:sort] == "release_date"? "hilite":"";
    @rate =  params[:ratings]
    @movies = Movie.all.where({rating: params[:ratings].keys}).order(params[:sort]) 
  end

  def new
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
end
