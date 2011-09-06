class Track < ActiveRecord::Base
  
  belongs_to :genre
  has_many :soundcloud_tracks
  has_many :likes
  has_and_belongs_to_many :artists
  
  def full_name
    "#{artists.collect(&:name).join(', ')} - #{name} (#{mix_name})"
  end
  
  def liked?(ip)
    Like.select("id").where(:track_id => id, :ip => ip).size > 0
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
