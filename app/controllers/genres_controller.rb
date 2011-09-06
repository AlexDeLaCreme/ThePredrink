class GenresController < ApplicationController
  
  def show
    params[:id] ||= Genre.first.id
    @genre = Genre.find params[:id]
    
    @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 18, :page => params[:page], :conditions => ["genre_id = ? and tracks.updated_at > ?", @genre.id, 2.days.ago], :include => [:artists, :genre]
    all_tracks = Track.find :all, :joins => :soundcloud_tracks, :order => "likes_count DESC", :conditions => ["genre_id = ? and tracks.updated_at > ?", @genre.id, 2.days.ago], :include => [:artists, :genre]
    session[:tracks] = all_tracks.collect &:id
    
    respond_to { |format|
      format.js {
        render :update do |page|
          page.replace_html :tracklist, render("show")
          page << "updateTrackMouseOvers();"
          page << "setDash('#{@genre.name.parameterize}');"
          unless session[:current_playing_id].nil?
            page << "jQuery('#track-#{session[:current_playing_id]}').fadeTo('fast', 1); jQuery('#track-#{session[:current_playing_id]}').unbind('mouseleave', mouseLeave);"
          end  
        end
      }
    }
  end
end
