# USAGE: rake RAILS_ENV=production --rakefile ./ThePredrink/Rakefile update_db --trace

require 'net/http'
require 'json'
require 'uri'

desc "Update the database from Beatport and Soundcloud"

task :update_db => :environment do
  puts "Updating the database from Beatport and Soundcloud..."
  CLIENT_ID = '481c7032a27349882e9c8b4498a34d89'
  
  genres = Genre.all

    genres.each { |genre|
      puts "Processing genre #{genre.name}..."
      
      begin
        uri = URI.parse("http://api.beatport.com/catalog/most-popular/genre?format=json&v=1.0&id=#{genre.beatport_genre_id}&page=1&perPage=100")
  
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
  
        response = http.request(request)
        # response.code
        tracks = JSON.parse(response.body, :symbolize_names => true)[:results]
        
        puts "Received tracks from Beatport"
      
        tracks.each { |track|
          unless Track.where(:beatport_track_id => track[:id]).empty?
            # update updated_at field -- this way we know it's recent
            puts "Have this track already -- updating 'updated_at' field"
            
            Track.record_timestamps = false
            
            t = Track.find(track[:id])
            t.updated_at = Time.now
            t.save
            
            Track.record_timestamps = true
          else
            puts "Adding new track..."
            
            # add new track to the DB only if it's not in there yet
            t = Track.new
            t.beatport_track_id = track[:id]
            t.name = track[:name]
            t.position = track[:position]
            t.genre_id = genre.id
            t.mix_name = track[:mixName]
    
            # if this is a top 10 track -- add +5 likes
            if t.position <= 10
              puts "Adding 5 likes..."
              
              5.times do
                l = Like.new
                l.IP = "0.0.0.0"
                l.save
                t.likes << l
              end
            end
    
            # add artists if needed
            artists = track[:artists]
    
            query_string = ""
    
            artists.each { |artist|
              if Artist.where(:beatport_artist_id => artist[:id]).empty?
                puts "Adding new artist..."
                
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
            
            puts "Getting matches from Soundcloud..."
            
            begin
              url = "http://api.soundcloud.com/tracks.json?client_id=#{CLIENT_ID}&q=#{query_string}&types=original,remix&filter=public,streamable"
              uri = URI.parse(url)
      
              http = Net::HTTP.new(uri.host, uri.port)
              request = Net::HTTP::Get.new(uri.request_uri)
              response = http.request(request);
      
              tracks_found_on_sc = JSON.parse(response.body, :symbolize_names => true)
              
              unless tracks_found_on_sc.empty?
                puts "Soundcloud match found"
                
                sc_t = tracks_found_on_sc.first
                sc_track = SoundcloudTrack.new
                sc_track.soundcloud_id = sc_t[:id]
                
                sc_track.url = sc_t[:permalink_url]
                sc_track.stream_url = sc_t[:stream_url]
                sc_track.duration = sc_t[:duration]
      
                t.soundcloud_tracks << sc_track
      
                sc_track.save
              end
            rescue
              puts "Error #{$!}"
            ensure
              t.save 
            end
          end
        }
      rescue
        puts "Error #{$!}"
      ensure 
      end
    }
end
