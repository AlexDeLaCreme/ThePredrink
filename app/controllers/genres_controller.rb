class GenresController < ApplicationController
  
  def show
    params[:id] ||= Genre.first.id
    @genre = Genre.find params[:id]
    
    @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 18, :page => params[:page], :conditions => ["genre_id = ? and tracks.updated_at > ?", @genre.id, 2.days.ago], :include => [:artists, :genre]
    all_tracks = Track.find :all, :joins => :soundcloud_tracks, :order => "likes_count DESC", :conditions => ["genre_id = ? and tracks.updated_at > ?", @genre.id, 2.days.ago], :include => [:artists, :genre]
    session[:tracks] = all_tracks.collect &:id
    
    respond_to { |format|
      format.js 
    }
  end
end
