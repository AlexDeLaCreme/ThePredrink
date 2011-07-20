class Like < ActiveRecord::Base
  
  belongs_to :track, :counter_cache => true
  
end
