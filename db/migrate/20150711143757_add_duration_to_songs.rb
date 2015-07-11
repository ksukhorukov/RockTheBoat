class AddDurationToSongs < ActiveRecord::Migration
  def change
  	add_column :songs, :human_readable_duration, :string
  	rename_column :songs, :duration, :duration_seconds
  end
end
