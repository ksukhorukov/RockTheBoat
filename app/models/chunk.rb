class Chunk < ActiveRecord::Base
	mount_uploader :chunk, ChunkUploader
	belongs_to :songs
end