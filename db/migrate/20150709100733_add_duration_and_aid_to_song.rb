class AddDurationAndAidToSong < ActiveRecord::Migration
  def change
  	add_column :songs, :aid, :integer
  	add_column :songs, :duration, :integer
  end
end
