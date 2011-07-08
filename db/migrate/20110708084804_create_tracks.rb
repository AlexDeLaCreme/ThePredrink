class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :soundcloud_url
      t.decimal :position
      t.decimal :beatport_genre_id
      t.string :mix_name
      t.decimal :beatport_track_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
