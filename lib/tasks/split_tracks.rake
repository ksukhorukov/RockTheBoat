namespace :app do
  desc "Split downloaded tracks on chunks"
  task split_tracks: :environment do
  	FileUtils.cd 'tmp/chunks'
  	songs = Song.all 
  	songs.each do |song|
  		unless song.chunks.any?
  			song_path = song.track.file.path
  			song_basename = song.track.file.basename
  			duration = song.duration
  			counter = 0
  			(0..duration).step(60) do |x| 
  				system "ffmpeg -ss #{x} -i #{song_path} -c copy -t 60 #{song_basename}-chunk-#{counter}.mp3" 
  				part = Chunk.new
  				File.open("#{song_basename}-chunk-#{counter}.mp3") { |f| part.chunk = f }
  				part.part_number = counter
  				part.song_id = song.id
  				part.save!
  				counter += 1
  			end
  			FileUtils.rm Dir.glob('*.mp3')
  			puts "Chunks for #{song_path} created"
  		end
  	end
  end
end
