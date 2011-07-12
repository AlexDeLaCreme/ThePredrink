class CreateArtistsTracksJoin < ActiveRecord::Migration
  def self.up
    create_table 'artists_tracks', :id => false do |t|
      t.column 'artist_id', :integer
      t.column 'track_id', :integer
    end
  end

  def self.down
    drop_table 'artists_tracks'
  end
end
