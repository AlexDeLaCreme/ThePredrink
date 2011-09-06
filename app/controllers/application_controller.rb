class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'net/http'
  require 'json'
  require 'uri'

  @@CLIENT_ID = '481c7032a27349882e9c8b4498a34d89'

  def index
    params[:show] ||= 'last-update'
    
    case params[:show]
    when 'this-week'
      @tracks = Track.joins(:soundcloud_tracks, :likes).select("tracks.*, COUNT(tracks.id) AS likes_this_week").group("tracks.id").paginate :per_page => 18, :page => params[:page], :order => 'likes_this_week DESC', :conditions => ["likes.created_at > ?", 1.week.ago], :include => [:artists, :genre, :likes]
      all_tracks = Track.find :all, :joins => [:soundcloud_tracks, :likes], :select => "tracks.*, COUNT(tracks.id) AS likes_this_week", :group => "tracks.id", :order => 'likes_this_week DESC', :conditions => ["likes.created_at > ?", 1.week.ago], :include => [:artists, :genre, :likes]
    when 'this-month'
      @tracks = Track.joins(:soundcloud_tracks, :likes).select("tracks.*, COUNT(tracks.id) AS likes_this_month").group("tracks.id").paginate :per_page => 18, :page => params[:page], :order => 'likes_this_month DESC', :conditions => ["likes.created_at > ?", 1.month.ago], :include => [:artists, :genre, :likes]
      all_tracks = Track.find :all, :joins => [:soundcloud_tracks, :likes], :select => "tracks.*, COUNT(tracks.id) AS likes_this_month", :group => "tracks.id", :order => 'likes_this_month DESC', :conditions => ["likes.created_at > ?", 1.month.ago], :include => [:artists, :genre, :likes]
    when 'all-time'
      @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 18, :page => params[:page], :include => [:artists, :genre]
      all_tracks = Track.find :all, :joins => :soundcloud_tracks, :order => "likes_count DESC", :include => [:artists, :genre]
    else
      @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 18, :page => params[:page], :conditions => ["tracks.updated_at > ?", 2.days.ago], :include => [:artists, :genre]
      all_tracks = Track.find :all, :joins => :soundcloud_tracks, :order => "likes_count DESC", :conditions => ["tracks.updated_at > ?", 2.days.ago], :include => [:artists, :genre]
    end
    
    session[:tracks] = all_tracks.collect &:id
    
    respond_to { |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html :tracklist, render("index")
          page << "updateTrackMouseOvers();"
          page << "setDash('all');"
          unless session[:current_playing_id].nil?
            page << "jQuery('#track-#{session[:current_playing_id]}').fadeTo('fast', 1); jQuery('#track-#{session[:current_playing_id]}').unbind('mouseleave', mouseLeave);"
          end  
        end
      }
    }
  end

  def clean_db
    Like.delete_all
    Track.delete_all
    Artist.delete_all
    SoundcloudTrack.delete_all
  end

  def sc
    uri = URI.parse("http://api.beatport.com/catalog/most-popular/genre?format=json&v=1.0&id=#{Genre.first.beatport_genre_id}&page=1&perPage=100")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    # response.code
    tracks = JSON.parse(response.body, :symbolize_names => true)[:results]
    # add tracks to the DB
    tracks.each { |track|
      logger.debug track[:length]
      logger.debug track[:rtmpStreamUrl]
    #  t = Track.new
    #  t.beatport_track_id = track[:id]
    #  t.name = track[:name]
    }
    

    respond_to do |format|
      format.html # sc.html.erb
      format.xml  { render :xml => JSON.parse(response.body)}
    end
  end
end
