# Add methods to load and access resources
module Lotu
  module Resourceful
    def load_resources(path)
      @_resources ||= {}
      path = File.join(@_game_path, path)

      # Load all the images in path
      Dir.entries(path).select do |entry|
        entry =~ /\.png|\.jpg|\.bmp/
      end.each do |entry|
        begin
          @_resources[entry] = Gosu::Image.new($window, File.join(path, entry))
        rescue Exception => e
          puts e, File.join(path,entry)
        end
      end

      # Load all the sounds in path
      Dir.entries(path).select do |entry|
        entry =~ /\.ogg|\.mp3|\.wav/
      end.each do |entry|
        begin
          @_resources[entry] = Gosu::Sample.new($window, File.join(path, entry))
        rescue Exception => e
          puts e, File.join(path,entry)
        end
      end
    end

    def set_game_path(path)
      @_game_path = File.expand_path(File.dirname path)
    end

    def resource(name)
      @_resources[name]
    end
  end
end
