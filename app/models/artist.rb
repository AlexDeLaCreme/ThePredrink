class Artist < ActiveRecord::Base
  
  has_and_belongs_to_many :tracks
  
  self.primary_key = 'beatport_artist_id'
  
end
