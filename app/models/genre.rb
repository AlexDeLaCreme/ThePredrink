class Genre < ActiveRecord::Base
  
  has_many :tracks
  
  self.primary_key = 'beatport_genre_id'
  
end
