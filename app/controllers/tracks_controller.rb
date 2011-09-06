class TracksController < ApplicationController
  
  def play
    @track = Track.find params[:id]
    @genre_id = params[:genre_id]
    @show = params[:show] || 'last-update'
    
    respond_to { |format|
      format.js
    }
  end
  
  def like
    # check for like for this track from this IP in the last 24 hours
    already_likes = Like.find(:all, :limit => 1, :conditions => {:IP => request.remote_ip, :track_id => params[:id], :created_at => 24.hours.ago..DateTime.now}).count
    
    # logger.debug already_likes.inspect
    
    track = Track.find params[:id]
    
    @likes_num = track.likes.length
    
    if already_likes == 0
      # the track has not been liked by this IP in the last 24 hrs -- add a new like
      like = Like.new
      like.IP = request.remote_ip
      like.save
     
      track.likes << like
      track.save    
     
      @likes_num = track.likes.length
        
      Track.update_counters track.id, :likes_count => @likes_num        
    end
        
    respond_to { |format|
      format.js { 
        if already_likes == 0 
          render :update do |page|
            # page << "var t = jQuery('#track-#{params[:id]} a.track').text(); jQuery('#track-#{params[:id]} a.track').text(t + ' + 1');"
            # update likes count
            page << "jQuery('#track-#{params[:id]} .likes-count').text('#{pluralize(@likes_num, 'like')}');"
            # say 'you liked this'
            page << "jQuery('#track-#{params[:id]} .you-liked-this').css('display', 'inline-block');"
          end
        end
      }
    }
  end
  
  def next
  end
  
  def previous
  end
end
