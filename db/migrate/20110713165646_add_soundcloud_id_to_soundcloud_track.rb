class AddSoundcloudIdToSoundcloudTrack < ActiveRecord::Migration
  def self.up
    add_column :soundcloud_tracks, :soundcloud_id, :integer
  end

  def self.down
    remove_column :soundcloud_tracks, :soundcloud_id
  end
end
