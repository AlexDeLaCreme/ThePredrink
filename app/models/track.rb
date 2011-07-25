class Track < ActiveRecord::Base
  
  belongs_to :genre
  has_many :soundcloud_tracks
  has_many :likes
  has_and_belongs_to_many :artists
  
  def full_name
    "#{self.artists.collect(&:name).join(', ')} - #{self.name} (#{self.mix_name})"
  end
  
  def next genre_id = nil
    if genre_id.nil?
      tracks = Track.find(:all, :select => "tracks.id", :joins => :soundcloud_tracks, :order => "likes_count DESC")
    else
      tracks = Track.find(:all, :select => "tracks.id", :joins => :soundcloud_tracks, :order => "likes_count DESC", :conditions => ["genre_id = ?", genre_id])
    end
    ids = tracks.collect(&:id)
    i = ids.index self.id
    if i == ids.size-1
      Track.find ids.first
    else
      Track.find ids[i+1]    
    end
  end
  
  def previous genre_id = nil
    if genre_id.nil?
      tracks = Track.find(:all, :select => "tracks.id", :joins => :soundcloud_tracks, :order => "likes_count DESC")
    else
      tracks = Track.find(:all, :select => "tracks.id", :joins => :soundcloud_tracks, :order => "likes_count DESC", :conditions => ["genre_id = ?", genre_id])
    end
    ids = tracks.collect(&:id)
    i = ids.index self.id
    if i == 0
      Track.find ids.last
    else
      Track.find ids[i-1]    
    end
  end
end
