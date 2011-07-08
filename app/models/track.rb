class Track < ActiveRecord::Base
  
  belongs_to :genre
  has_and_belongs_to_many :artists
  
  self.primary_key = 'beatport_track_id'
  
end
