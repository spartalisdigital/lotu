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
      load_resources(@images, /\.png|\.jpg|\.bmp/, path, Gosu::Image)
    end

    def load_sounds(path)
      load_resources(@sounds, /\.ogg|\.mp3|\.wav/, path, Gosu::Sample)
    end

    def load_songs(path)
      load_resources(@songs, /\.ogg|\.mp3|\.wav/, path, Gosu::Song)
    end

    def with_path(path, &blk)
      @path = File.expand_path(File.dirname path)
      yield
    end

    def load_resources(container, regexp, path, klass)
      path = File.expand_path(File.join(@path, path))
      puts "Loading from: #{path}"

      count = 0
      Dir.entries(path).grep(regexp).each do |entry|
        begin
          container[entry] = klass.new($window, File.join(path, entry))
          count += 1
        rescue Exception => e
          puts e, File.join(path, entry)
        end
      end
      puts "#{count} #{klass} files loaded."
    end

  end
end
