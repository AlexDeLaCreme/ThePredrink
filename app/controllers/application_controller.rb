class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'net/http'
  require 'json'
  require 'uri'

  @@CLIENT_ID = '481c7032a27349882e9c8b4498a34d89'

  def index
    @tracks = Track.joins(:soundcloud_tracks).order("likes_count DESC").paginate :per_page => 20, :page => params[:page], :include => [:artists, :genre]

    respond_to { |format|
      format.html
      format.js
    }
  end

  def update_db
    # clean DB first
    Like.delete_all
    Track.delete_all
    Artist.delete_all
    SoundcloudTrack.delete_all

    genres = Genre.all

    genres.each { |genre|
      uri = URI.parse("http://api.beatport.com/catalog/most-popular/genre?format=json&v=1.0&id=#{genre.beatport_genre_id}&page=1&perPage=100")

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      # response.code
      tracks = JSON.parse(response.body, :symbolize_names => true)[:results]
      # add tracks to the DB
      tracks.each { |track|
        t = Track.new
        t.beatport_track_id = track[:id]
        t.name = track[:name]
        t.position = track[:position]
        t.genre_id = genre.id
        t.mix_name = track[:mixName]

        # add artists if needed
        artists = track[:artists]

        query_string = ""

        artists.each { |artist|
          if Artist.where(:beatport_artist_id => artist[:id]).empty?
            a = Artist.new
            a.beatport_artist_id = artist[:id]
            a.name = artist[:name]
            a.save

            t.artists << a
          else
            a = Artist.find_by_beatport_artist_id(artist[:id])
            t.artists << a
          end
          query_string = a.name.parameterize('+') + "+" + query_string
        }

        #search for matching tracks on Soundcloud
        query_string = t.name.parameterize('+') + "+" + query_string

        url = "http://api.soundcloud.com/tracks.json?client_id=#{@@CLIENT_ID}&q=#{query_string}&types=original,remix&filter=public,streamable"
        uri = URI.parse(url)

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request);

        tracks_found_on_sc = JSON.parse(response.body, :symbolize_names => true)

        unless tracks_found_on_sc.empty?
          sc_t = tracks_found_on_sc.first
          sc_track = SoundcloudTrack.new
          sc_track.soundcloud_id = sc_t[:id]
          
          sc_track.url = sc_t[:permalink_url]
          sc_track.stream_url = sc_t[:stream_url]
          sc_track.duration = sc_t[:duration]

          t.soundcloud_tracks << sc_track

          sc_track.save
        end

        t.save
      }
    }
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
