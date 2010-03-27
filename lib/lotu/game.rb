module Lotu
  class Game < Gosu::Window
    # Accessors for time delta, systems and fonts
    attr_reader :dt, :systems, :fonts
    # Accessors for queues
    attr_accessor :update_queue, :draw_queue, :input_listeners

    include SystemUser

    def initialize(params={})
      super(800, 600, false)

      # Handy global window variable
      $lotu = self
      @debug = false
      setup_containers

      # For timer initialization
      @last_time = Gosu::milliseconds
      # Memoize fonts by size
      @fonts = Hash.new{|h,k| h[k] = Gosu::Font.new(self, Gosu::default_font_name, k)}

      # Call hook methods
      load_resources
      setup_systems
      setup_actors
      setup_input
    end

    def debug!
      @debug = !@debug
    end

    def debug?
      @debug
    end

    # Hook methods, these are meant to be replaced by subclasses
    def load_resources;end
    def setup_actors;end
    def setup_input;end

    def setup_systems
      use(InputSystem)
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
      @animations = Hash.new{|h,k| h[k] = []}
    end

    # Main update loop
    def update
      new_time = Gosu::milliseconds
      @dt = (new_time - @last_time)/1000.0
      @last_time = new_time

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

    # For actor management
    def manage_me(actor)
      @draw_queue << actor
      @update_queue << actor
    end

    def kill_me(actor)
      @draw_queue.delete(actor)
      @update_queue.delete(actor)
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
        @images[file_name] = Gosu::Image.new($lotu, file_path)
      end
    end

    def load_sounds(path)
      with_files(/\.ogg|\.mp3|\.wav/, path) do |file_name, file_path|
        @sounds[file_name] = Gosu::Sample.new($lotu, file_path)
      end
    end

    def load_songs(path)
      with_files(/\.ogg|\.mp3|\.wav/, path) do |file_name, file_path|
        @songs[file_name] = Gosu::Song.new($lotu, file_path)
      end
    end

    def load_animations(path)
      coords = Hash.new{|h,k| h[k] = []}

      with_files(/\.txt/, path) do |file_name, file_path|
        name = File.basename(file_name, '.txt')
        File.open(file_path) do |file|
          file.lines.each do |line|
            coords[name] << line.scan(/\d+/).map!(&:to_i)
          end
        end
      end

      with_files(/\.png|\.jpg|\.bmp/, path) do |file_name, file_path|
        name, extension = file_name.split('.')
        coords[name].each do |index, x, y, width, height|
          @animations[file_name] << Gosu::Image.new($lotu, file_path, true, x, y, width, height)
        end
      end
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
      puts "\n#{count} file(s) loaded."
    end

  end
end
