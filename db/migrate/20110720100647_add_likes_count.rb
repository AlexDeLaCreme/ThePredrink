class AddLikesCount < ActiveRecord::Migration
  def self.up
    add_column :tracks, :likes_count, :integer, :default => 0
    
    Track.reset_column_information
    Track.find(:all).each do |t|
      Track.update_counters t.id, :likes_count => t.likes.length
    end
  end

  def self.down
    remove_column :tracks, :likes_count
  end
end
