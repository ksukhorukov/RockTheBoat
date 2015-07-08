namespace :app do 
	desc "Download tracks from VK"
	task :download_tracks => :environment do 
		token = ENV["VK_TOKEN"]
		app = VK::Application.new(app_id: 4988400, version: '0.1', access_token: token)
		query = 'Woodstock'
		results = app.audio.search(q:  query, count: 100)
		#TODO
	end
end