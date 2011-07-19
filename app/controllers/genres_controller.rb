class GenresController < ApplicationController
  
  def show
    params[:id] ||= Genre.first.id
    @genre = Genre.find params[:id]
    @tracks = Track.joins(:soundcloud_tracks).paginate :per_page => 20, :page => params[:page], :conditions => ["genre_id = ?", @genre.id]
    respond_to { |format|
      format.js 
    }
  end
end
