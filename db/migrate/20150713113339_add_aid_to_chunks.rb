class AddAidToChunks < ActiveRecord::Migration
  def change
  	add_column :chunks, :aid, :integer
  	add_index :chunks, :aid
  end
end
