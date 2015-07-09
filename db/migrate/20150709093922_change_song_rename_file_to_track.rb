class ChangeSongRenameFileToTrack < ActiveRecord::Migration
  def change
  	rename_column :songs, :file, :track
  end
end
