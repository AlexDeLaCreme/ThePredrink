class Track < ActiveRecord::Base
  
  belongs_to :genre
  has_many :soundcloud_tracks
  has_and_belongs_to_many :artists
  
end
