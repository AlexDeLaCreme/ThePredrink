class AddStreamUrlAndDurationToSoundcloudTracks < ActiveRecord::Migration
  def self.up
    add_column :soundcloud_tracks, :stream_url, :string
    add_column :soundcloud_tracks, :duration, :integer
  end

  def self.down
    remove_column :soundcloud_tracks, :duration
    remove_column :soundcloud_tracks, :stream_url
  end
end
