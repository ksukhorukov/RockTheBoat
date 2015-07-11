class Song < ActiveRecord::Base
	mount_uploader :track, TrackUploader
	process_in_background :track
	has_many :chunks, dependent: :destroy
end
