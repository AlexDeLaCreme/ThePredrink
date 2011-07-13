class AddTrackIdToSoundcloudTrack < ActiveRecord::Migration
  def self.up
    add_column :soundcloud_tracks, :track_id, :integer
  end

  def self.down
    remove_column :soundcloud_tracks, :track_id
  end
end
