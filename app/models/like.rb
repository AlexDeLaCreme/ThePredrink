class Like < ActiveRecord::Base
  
  belongs_to :track, :counter_cache => true
  
  def self.this_week
    Like.where "created_at > ?", [1.week.ago]
  end
  
  def self.this_month
    Like.where "created_at > ?", [1.month.ago]
  end
  
end
