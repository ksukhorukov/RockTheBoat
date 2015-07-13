class RemoveSongIdFromChunk < ActiveRecord::Migration
  def change
  	remove_column :chunks, :song_id
  end
end
