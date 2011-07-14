class RemoveColorFromGenre < ActiveRecord::Migration
  def self.up
    remove_column :genres, :color
  end

  def self.down
    add_column :genres, :color, :string
  end
end
