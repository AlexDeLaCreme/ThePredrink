class Track < ActiveRecord::Base
  
  belongs_to :genre
  has_many :soundcloud_tracks
  has_many :likes
  has_and_belongs_to_many :artists
  
  def full_name
    "#{self.artists.collect(&:name).join(', ')} - #{self.name} (#{self.mix_name})"
  end
end
