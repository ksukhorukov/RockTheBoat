class AlterSongsChangeNameToTile < ActiveRecord::Migration
  def change
  	rename_column :songs, :name, :title
  end
end
