class SoundcloudTrack < ActiveRecord::Base

  belongs_to :track
  
  def pretty_duration
    self.milliseconds_to_time(self.duration)
  end

  protected

  def milliseconds_to_time(millis)
    minutes = millis / 1000 / 60
    seconds =  millis / 1000 - minutes * 60
    
    sprintf "%1.1d:%2.2d", minutes, seconds
  end

end
