class RemoveSoundcloudTrackIdFromTrack < ActiveRecord::Migration
  def self.up
    remove_column :tracks, :soundcloud_track_id
  end

  def self.down
    add_column :tracks, :soundcloud_track_id, :integer
  end
end
