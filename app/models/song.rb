class Song < ActiveRecord::Base
	
	mount_uploader :track, TrackUploader
	store_in_background :track
	self.primary_key = :aid
	has_many :chunks, -> { order('part_number') }, dependent: :destroy, :foreign_key => :aid

	validates :aid, :artist, :title, :track, presence: true
end
