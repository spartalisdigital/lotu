# Add methods to load and access images, sounds & songs
module Lotu
  module Resourceful

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior
      @images = {}
      @sounds = {}
      @songs = {}
    end

    def image(name)
      @images[name]
    end

    def sound(name)
      @sounds[name]
    end

    def song(name)
      @songs[name]
    end

    def load_images(path)
      with_files(/\.png|\.jpg|\.bmp/, path) do |file_name, file_path|
        @images[file_name] = Gosu::Image.new($window, file_path)
      end
    end

    def load_sounds(path)
      with_files(/\.ogg|\.mp3|\.wav/, path) do |file_name, file_path|
        @sounds[file_name] = Gosu::Sample.new($window, file_path)
      end
    end

    def load_songs(path)
      with_files(/\.ogg|\.mp3|\.wav/, path) do |file_name, file_path|
        @songs[file_name] = Gosu::Song.new($window, file_path)
      end
    end

    def with_path_from_file(path, &blk)
      @path = File.expand_path(File.dirname path)
      yield
    end

    def with_files(regexp, path)
      path = File.expand_path(File.join(@path, path))
      puts "Loading from: #{path}"

      count = 0
      Dir.entries(path).grep(regexp).each do |entry|
        begin
          yield(entry, File.join(path, entry))
          count += 1
        rescue Exception => e
          puts e, File.join(path, entry)
        end
      end
      puts "#{count} files loaded."
    end

  end
end
