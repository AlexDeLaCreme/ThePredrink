class AddTrackIdToLike < ActiveRecord::Migration
  def self.up
    add_column :likes, :track_id, :integer
  end

  def self.down
    remove_column :likes, :track_id
  end
end
