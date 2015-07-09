class AddPartNumberToChunk < ActiveRecord::Migration
  def change
  	add_column :chunks, :part_number, :integer
  end
end
