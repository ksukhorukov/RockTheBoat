class Song < ActiveRecord::Base
	mount_uploader :track, TrackUploader
	#process_in_background :track
	#store_in_background :track
	self.primary_key = :aid
	has_many :chunks, -> { order('part_number') }, dependent: :destroy, :foreign_key => :aid
end
