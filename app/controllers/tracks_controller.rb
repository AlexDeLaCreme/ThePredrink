class TracksController < ApplicationController
  
  def play
    respond_to { |format|
      format.js
    }
  end
  
  def like
    respond_to { |format|
      format.js
    }
  end
end
