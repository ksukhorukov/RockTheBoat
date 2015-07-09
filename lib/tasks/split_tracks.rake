namespace :app do
  desc "Split downloaded tracks on chunks"
  task split_tracks: :environment do
  	songs = Songs.all 
  	
  end
end
