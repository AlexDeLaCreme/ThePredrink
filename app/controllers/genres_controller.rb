class GenresController < ApplicationController
  
  def show
    params[:id] ||= Genre.first.id
    @genre = Genre.find params[:id]
    
    @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 25, :page => params[:page], :conditions => ["genre_id = ?", @genre.id], :include => [:artists, :genre]
    respond_to { |format|
      format.js 
    }
  end
end
