class AddSoundcloudTrackIdToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :soundcloud_track_id, :integer
  end

  def self.down
    remove_column :tracks, :soundcloud_track_id
  end
end
