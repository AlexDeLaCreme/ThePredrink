class RemoveSoundcloudUrlFromTrack < ActiveRecord::Migration
  def self.up
    remove_column :tracks, :soundcloud_url
  end

  def self.down
    add_column :tracks, :soundcloud_url, :string
  end
end
