module Lotu
  class Window < Gosu::Window
    # Accessors for time delta, systems and fonts
    attr_reader :dt, :systems, :fonts
    # Accessors for queues
    attr_accessor :update_queue, :draw_queue, :input_listeners

    include ActorManager
    #include InputManager

    def initialize(params={})
      super(800, 600, false)

      # Handy global window variable
      $window = self
      @debug = true
      setup_containers

      @fps_counter = FpsCounter.new
      @last_time = Gosu::milliseconds
      @fonts = Hash.new{|h,k| h[k] = Gosu::Font.new(self, Gosu::default_font_name, k)}

      # Add extra functionality
      extend Controllable
      extend Systems::Collision
    end

    # Setup various containers
    def setup_containers
      # For systems
      @systems = {}

      # For queues
      @update_queue = []
      @draw_queue = []
      @input_register = Hash.new{|hash,key| hash[key] = []}

      # For resource management
      @images = {}
      @sounds = {}
      @songs = {}
      @animations = {}
    end

    # Main update loop
    def update
      new_time = Gosu::milliseconds
      @dt = (new_time - @last_time)/1000.0
      @last_time = new_time
      @fps_counter.update(@dt)

      # Update each system
      @systems.each_value do |system|
        system.update
      end

      # Update each actor
      @update_queue.each do |actor|
        actor.update
      end
    end

    # Main draw loop
    def draw
      # Systems may report interesting stuff
      @systems.each_value do |system|
        system.draw
      end

      # Draw each actor in queue
      @draw_queue.each do |actor|
        actor.draw
      end
    end

    # These are for managing input
    def button_down(id)
      @input_register[id].each do |item|
        item.button_down(id)
      end
    end

    def button_up(id)
      @input_register[id].each do |item|
        item.button_up(id)
      end
    end

    def register_for_input(controller)
      controller.keys.each_key do |key|
        @input_register[key] << controller
      end
      @update_queue << controller
    end

    # These are for managing resources
    def image(name)
      @images[name]
    end

    def sound(name)
      @sounds[name]
    end

    def song(name)
      @songs[name]
    end

    def animation(name)
      @animations[name]
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

    def load_animations(path)
      path = File.expand_path(File.join(@path, path))
      puts "Loading from: #{path}"

      count = 0
      Dir.entries(path).grep(regexp).each do |entry|
        begin
          @animations[entry] = klass.new($window, File.join(path, entry))
          count += 1
        rescue Exception => e
          puts e, File.join(path, entry)
        end
      end
      puts "#{count} #{klass} files loaded."
    end

    def with_path_from_file(path, &blk)
      @path = File.expand_path(File.dirname path)
      yield
    end

    def with_files(regexp, path)
      path = File.expand_path(File.join(@path, path))
      puts "\nLoading from: #{path}"

      count = 0
      Dir.entries(path).grep(regexp).each do |entry|
        begin
          yield(entry, File.join(path, entry))
          count += 1
          print '.'.green
        rescue Exception => e
          print '.'.red
          puts e, File.join(path, entry) if @debug
        end
      end
      puts "\n#{count} files loaded."
    end

  end
end
