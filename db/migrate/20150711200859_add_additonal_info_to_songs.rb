class AddAdditonalInfoToSongs < ActiveRecord::Migration
  def change
  	add_column :songs, :genre, :string
  	add_column :songs, :release_year, :string
  	add_column :songs, :album, :string
  end
end
