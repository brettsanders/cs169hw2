class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    # if params[:sort].nil? && params[:ratings].nil? &&
    #     (!session[:sort].nil? || !session[:ratings].nil?)
    #   redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    # end
  
    @movies = Movie.order(params[:sort])
    @movies = @movies.where("rating IN (?)", params[:ratings])
 
    @all_ratings = Movie.all_ratings

    # working code
    if !params[:ratings]
      # @selected_ratings = @all_ratings
      params[:ratings] = @all_ratings
      if session[:ratings]
        @selected_ratings = session[:ratings]
      end
      @movies = Movie.order(params[:sort])
    else
      @selected_ratings = (params[:ratings].present? ? params[:ratings] : [])
    end

    if !params[:sort]
      if session[:sort]
        params[:sort] = session[:sort]
      end
    end
    
    # way to refactor this?
    case
    when params[:sort] == "title"
      @title_class = "hilite"
    when params[:sort] == "release_date"
      @released_class = "hilite"
    end
    
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
