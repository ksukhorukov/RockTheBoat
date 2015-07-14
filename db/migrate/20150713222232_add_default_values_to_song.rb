class AddDefaultValuesToSong < ActiveRecord::Migration
  def change
  	change_column :songs, :release_year, :string, :default => 'unknown'
  	change_column :songs, :album, :string, :default => 'unknown'
  	change_column :songs, :genre, :string, :default => 'unknown'
  end
end
