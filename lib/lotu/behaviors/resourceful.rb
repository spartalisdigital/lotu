# Add methods to load and access images, sounds & songs
module Lotu
  module Resourceful
    def is_resourceful
      include InstanceMethods
    end

    module InstanceMethods
      def init_behavior
        @_images = {}
        @_sounds = {}
        @_songs = {}
      end

      def image(name)
        @_images[name]
      end

      def sound(name)
        @_sounds[name]
      end

      def song(name)
        @_songs[name]
      end

      def load_images(path)
        load_resources(@_images, /\.png|\.jpg|\.bmp/, path, Gosu::Image)
      end

      def load_sounds(path)
        load_resources(@_sounds, /\.ogg|\.mp3|\.wav/, path, Gosu::Sample)
      end

      def load_songs(path)
        load_resources(@_songs, /\.ogg|\.mp3|\.wav/, path, Gosu::Song)
      end

      def with_path(path, &blk)
        @_path = File.expand_path(File.dirname path)
        yield
      end

      private
      def load_resources(container, regexp, path, klass)
        path = File.expand_path(File.join(@_path, path))
        puts "Loading from: #{path}"

        count = 0
        Dir.entries(path).select do |entry|
          entry =~ regexp
        end.each do |entry|
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
end
