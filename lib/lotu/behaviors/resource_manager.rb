module Lotu
  module ResourceManager

    attr_accessor :images, :sounds, :songs, :animations, :default_font

    def init_behavior opts
      super if defined? super
      @images = {}
      @sounds = {}
      @songs = {}
      @animations = Hash.new{ |h,k| h[k] = [] }
      @default_font = Hash.new{ |h,k| h[k] = Gosu::Font.new( self, Gosu::default_font_name, k ) }
    end

    # TODO: cambiar a Image['hola.png']
    def image( name )
      @images[name]
    end

    def sound( name )
      @sounds[name]
    end

    def song( name )
      @songs[name]
    end

    def animation(name)
      @animations[name]
    end

    def with_path_from_file(path, &blk)
      @path = File.expand_path(File.dirname path)
      instance_eval &blk
    end

    protected
    def load_images( path )
      count = 0
      with_files(/\.png$|\.jpg$|\.bmp$/, path) do |file_name, file_path|
        @images[file_name] = Gosu::Image.new($lotu, file_path)
        count += 1
      end
      puts "\n#{count} image(s) loaded."
    end

    def load_sounds(path)
      count = 0
      with_files(/\.ogg$|\.mp3$|\.wav$/, path) do |file_name, file_path|
        @sounds[file_name] = Gosu::Sample.new($lotu, file_path)
        count += 1
      end
      puts "\n#{count} sounds(s) loaded."
    end

    def load_songs(path)
      count = 0
      with_files(/\.ogg$|\.mp3$|\.wav$/, path) do |file_name, file_path|
        @songs[file_name] = Gosu::Song.new($lotu, file_path)
        count += 1
      end
      puts "\n#{count} song(s) loaded."
    end

    def load_animations(path)
      count = 0
      coords = Hash.new{|h,k| h[k] = []}

      with_files(/\.txt$/, path) do |file_name, file_path|
        name = File.basename(file_name, '.txt')
        File.open(file_path) do |file|
          file.lines.each do |line|
            coords[name] << line.scan(/\d+/).map!(&:to_i)
          end
        end
        false
      end

      with_files(/\.png$|\.jpg$|\.bmp$/, path) do |file_name, file_path|
        name, extension = file_name.split('.')
        coords[name].each do |index, x, y, width, height|
          @animations[file_name] << Gosu::Image.new($lotu, file_path, true, x, y, width, height)
        end
        count += 1 if coords[name]
      end
      puts "\n#{count} animation(s) loaded."
    end

    def with_files(regexp, path)
      path = File.expand_path(File.join(@path, path))
      puts "\nLoading from: #{path}".blue if @debug

      Dir.entries(path).grep(regexp).each do |entry|
        begin
          report = yield(entry, File.join(path, entry))
          print '.'.green if report
        rescue Exception => e
          print '.'.red
          puts e, File.join(path, entry) if @debug
        end
      end
    end

  end
end
