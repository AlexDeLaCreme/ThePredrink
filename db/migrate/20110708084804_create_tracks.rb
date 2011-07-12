class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :soundcloud_url
      t.integer :position
      t.integer :beatport_genre_id
      t.string :mix_name
      t.integer :beatport_track_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
