class Chunk < ActiveRecord::Base
	mount_uploader :chunk, ChunkUploader
	belongs_to :songs
	validates :aid, :chunk, :part_number, presence: true
	validates :aid, uniqueness: true
end