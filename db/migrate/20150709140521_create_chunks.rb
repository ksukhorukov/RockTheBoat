class CreateChunks < ActiveRecord::Migration
  def change
    create_table :chunks do |t|
    	t.string		 :chunk
    	t.belongs_to :song, index:true
    	t.timestamps
    end
  end
end

