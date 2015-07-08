class AddDetailsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :artist, :string
    add_column :songs, :name, :string
    add_column :songs, :file, :string
  end
end
