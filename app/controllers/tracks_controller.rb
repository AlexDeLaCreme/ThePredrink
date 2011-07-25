class TracksController < ApplicationController
  
  def play
    @track = Track.find params[:id]
    @genre_id = params[:genre_id]
    
    respond_to { |format|
      format.js
    }
  end
  
  def like
    # check for like for this track from this IP in the last 24 hours
    already_likes = Like.find(:all, :limit => 1, :conditions => {:IP => request.remote_ip, :track_id => params[:id], :created_at => 24.hours.ago..DateTime.now}).count
    
    logger.debug already_likes.inspect
    
    if already_likes == 0
      # the track has not been liked by this IP in the last 24 hrs -- add a new like
      like = Like.new
      like.IP = request.remote_ip
      like.save
     
      track = Track.find params[:id]
      track.likes << like
      track.save    
     
      @likes_num = track.likes.length
        
      Track.update_counters track.id, :likes_count => @likes_num        
    end
        
    respond_to { |format|
      format.js
    }
  end
  
  def next
  end
  
  def previous
  end
end
