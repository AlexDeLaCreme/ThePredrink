class FixGenreColumnName < ActiveRecord::Migration
  def self.up
    rename_column :genres, :genre, :name
  end

  def self.down
    rename_column :genres, :name, :genre
  end
end
