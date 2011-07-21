class TracksController < ApplicationController
  
  def play
    @track = Track.find params[:id]
    @duration =  @track.soundcloud_tracks.first.pretty_duration
    @stream_url = @track.soundcloud_tracks.first.stream_url
    
    respond_to { |format|
      format.js
    }
  end
  
  def like
    like = Like.new
    like.IP = request.remote_ip
    like.save
    
    track = Track.find params[:id]
    track.likes << like
    track.save    
    
    @likes_num = track.likes.length
       
    Track.update_counters track.id, :likes_count => @likes_num
        
    respond_to { |format|
      format.js
    }
  end
end
