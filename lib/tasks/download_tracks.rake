
namespace :app do 
	desc "Download tracks from VK"
	task :download_tracks => :environment do 
		app = VK::Application.new(app_id: Settings.vk.app_id, version: '0.1', access_token: Settings.vk.token)
		results = app.audio.search(q:  Settings.vk.query, count: Settings.vk.tracks_count)
		results.shift #we dont need the first element
		audio_ids = []
		results.each do |info|
			current_aid = info['aid']
			audio_ids << current_aid
			duration_seconds = info['duration']
			unless Song.find_by_aid(current_aid)
				song = Song.new(aid: current_aid, 
												title: info['title'], 
												artist: info['artist'],
												duration_seconds: duration_seconds,
												human_readable_duration: Time.at(duration_seconds).utc.strftime("%H:%M:%S"))
				song.track.download!(info['url'])
				song.save!
			end
		end
		Song.where('aid NOT IN (?)', audio_ids).destroy_all
	end
end