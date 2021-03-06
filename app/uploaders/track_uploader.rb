# encoding: utf-8

class TrackUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end


  process :set_bitrate 
  process :get_metadata
  process :create_parts

  def set_bitrate
    ffprobe = Ffprober::Parser.from_file(current_path)
    bitrate = ffprobe.audio_streams[0].bit_rate.to_i
    if bitrate > 128000
      infile  = current_path
      outfile = current_path + '.tmp'
      safe_system "ffmpeg -i #{infile} -ab 128k -f mp3 #{outfile}"
      FileUtils.mv outfile, infile
      @filename = File.basename(infile, File.extname(infile)) + '.mp3'
      puts "SETING UP BITRATE"
    end
  end

  def get_metadata
      ffprobe = Ffprober::Parser.from_file(current_path)  
      pp ffprobe 
      puts "current path: #{current_path}"  
      pp ffprobe.format   
      if ffprobe.format.respond_to? :tags
        model.release_year = ffprobe.format.tags[:date] || 'unknown'
        model.album =  ffprobe.format.tags[:album] || 'unknown'
        model.genre =  ffprobe.format.tags[:genre] || 'unknown'
      end
  end

  def create_parts
    tmp_dir = Rails.root.join('/tmp/chunk')
    FileUtils.mkdir(tmp_dir) unless Dir.exists?(tmp_dir)
    FileUtils.cd tmp_dir
    basename = File.basename current_path
    duration = model.duration_seconds
    counter = 0
    (0..duration).step(60) do |x| 
      system "ffmpeg -ss #{x} -i #{current_path} -c copy -t 60 #{basename}-chunk-#{counter}.mp3" 
      part = Chunk.new
      File.open("#{basename}-chunk-#{counter}.mp3") { |f| part.chunk = f }
      part.part_number = counter
      part.aid = model.aid
      part.save!
      counter += 1
    end
    FileUtils.rm Dir.glob('*.mp3')
    puts "Chunks for #{current_path} created"
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def safe_system *args
    system *args

    if $?.exitstatus > 0
      raise CarrierWave::ProcessingError,
          "Couldn't process #{File.basename(current_path)}. " \
          "Command failed: '#{args.join(' ')}'"
    end
  end

end
