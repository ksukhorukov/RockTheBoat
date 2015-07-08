class Song < ActiveRecord::Base
	mount_uploader :track, TrackUploader
end
