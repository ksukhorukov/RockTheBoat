class Song < ActiveRecord::Base
	mount_uploader :track, TrackUploader
	has_many :chunks, dependent: :destroy
end
