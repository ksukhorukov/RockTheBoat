class AddColumnsForBackgroundProcessing < ActiveRecord::Migration
  def change
  	add_column :songs, :track_processing, :boolean, null: false, default: false
  	add_column :songs, :track_tmp, :string
  end
end
