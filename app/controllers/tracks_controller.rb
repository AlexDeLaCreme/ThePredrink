class TracksController < ApplicationController
  
  def play
    @track = Track.find params[:id]
    
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
        
    respond_to { |format|
      format.js
    }
  end
end
