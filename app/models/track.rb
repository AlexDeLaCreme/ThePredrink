class Track < ActiveRecord::Base
  
  belongs_to :genre
  has_many :soundcloud_tracks
  has_many :likes
  has_and_belongs_to_many :artists
  
  def full_name
    "#{self.artists.collect(&:name).join(', ')} - #{self.name} (#{self.mix_name})"
  end
  
  def next_id ids
    i = ids.index self.id
    if i == ids.size-1
      ids.first
    else
      ids[i+1]
    end
  end
  
  def prev_id ids
    i = ids.index self.id
    if i == 0
      ids.last
    else
      ids[i-1]
    end
  end  
  
end
