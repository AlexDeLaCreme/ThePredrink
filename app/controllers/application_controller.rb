class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'net/http'
  require 'json'
  require 'uri'

  @@CLIENT_ID = '481c7032a27349882e9c8b4498a34d89'

  def index
    @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 18, :page => params[:page], :include => [:artists, :genre]

    respond_to { |format|
      format.html
      format.js
    }
  end

  def clean_db
    Like.delete_all
    Track.delete_all
    Artist.delete_all
    SoundcloudTrack.delete_all
  end

  def update_db
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
