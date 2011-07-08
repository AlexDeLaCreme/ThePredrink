class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def updateDB
    require 'net/http'
    require 'json'
    require 'uri'
    
    # clean DB first
    Track.delete_all
    Artist.delete_all

    genres = Genre.all
    
    genres.each { |genre|
      uri = URI.parse("http://api.beatport.com/catalog/most-popular/genre?format=json&v=1.0&id=#{genre.beatport_genre_id}&page=1&perPage=100")

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      # response.code         
      tracks = JSON.parse(response.body, :symbolize_names => true)[:results]
      tracks.each { |track|
        t = Track.new
        t.beatport_track_id = track[:id]
        t.name = track[:name]
        t.position = track[:position]
        t.beatport_genre_id = genre.beatport_genre_id
        t.mix_name = track[:mixName]
        t.save
        
        # add artists if needed
        artists = track[:artists]
        artists.each { |artist|
          if Artist.where(:beatport_artist_id => artist[:id]).empty?
            a = Artist.new
            a.beatport_artist_id = artist[:id]
            a.name = artist[:name]
            a.save
          end
        }
      }
    }
  end
  
end
