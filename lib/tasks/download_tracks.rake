
namespace :app do 
	desc "Download tracks from VK"
	task :download_tracks => :environment do 
		token = ENV["VK_TOKEN"]
		app = VK::Application.new(app_id: 4988400, version: '0.1', access_token: token)
		query = 'Woodstock'
		results = app.audio.search(q:  query, count: 10)
		results.shift #we dont need the first element
		audio_ids = []
		results.each do |info|
			current_aid = info['aid']
			audio_ids << current_aid
			unless Song.find_by_aid(current_aid)
				song = Song.new(aid: current_aid, title: info['title'], artist: info['artist'], duration: info['duration'])
				song.track.download!(info['url'])
				song.save!
			end
		end
		Song.where('aid NOT IN (?)', audio_ids).destroy_all
	end
end