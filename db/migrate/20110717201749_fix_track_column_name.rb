class FixTrackColumnName < ActiveRecord::Migration
  def self.up
    rename_column :tracks, :beatport_genre_id, :genre_id
  end

  def self.down
    rename_column :tracks, :genre_id, :beatport_genre_id
  end
end
