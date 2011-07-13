class CreateSoundcloudTracks < ActiveRecord::Migration
  def self.up
    create_table :soundcloud_tracks do |t|
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :soundcloud_tracks
  end
end
