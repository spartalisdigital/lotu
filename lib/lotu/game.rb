module Lotu
  class Game < Gosu::Window
    include Lotu::Helpers::Util
    extend Lotu::Behavior

    behave_like Lotu::SystemUser
    use Lotu::InputManagerSystem

    behave_like Lotu::ResourceManager

    # Accessors for elapsed time since last update (time delta) and debug
    attr_reader :dt, :debug
    # Accessors for queues
    attr_accessor :update_queue, :draw_queue, :input_listeners

    def initialize(opts={})
      # parse and merge options passed from
      # the CLI (Command Line Interface)
      # CLI options have the greatest precedence
      opts.merge!(parse_cli_options)

      # set some sane default opts
      default_opts = {
        :width => 1024,
        :height => 768,
        :fullscreen => false,
        :debug => false
      }
      # fill in any missing options using the defaults
      opts = default_opts.merge!(opts)

      # Handy global window variable
      $lotu = self

      # Game setup
      @debug = opts[:debug]
      @pause = false
      setup_containers

      # if debug is set, print out class info
      class_debug_info

      # call the Gosu::Window constructor
      super(opts[:width], opts[:height], opts[:fullscreen])

      # For timer initialization
      @last_time = Gosu::milliseconds

      # start behaving as
      init_behavior opts

      # Call hook methods
      load_resources
      setup_actors
      setup_input
      setup_events

      # if debug is set, print out instance info
      instance_debug_info
    end

    def fps
      Gosu::fps
    end

    def pause!
      @pause = !@pause
    end

    def paused?
      @pause
    end

    def debug!
      @debug = !@debug
    end

    def debug?
      @debug
    end

    # Hook methods, these are meant to be replaced by subclasses
    def load_resources; end
    def setup_actors; end
    def setup_input; end
    def setup_events; end

    # Setup various containers
    def setup_containers
      # For queues
      @update_queue = []
      @draw_queue = []
      @input_register = Hash.new{|hash,key| hash[key] = []}
    end

    # Main update loop
    def update
      new_time = Gosu::milliseconds
      @dt = (new_time - @last_time)/1000.0
      @last_time = new_time

      # to call update on behaviors (that in turn wil call
      # update on systems, for example)
      super

      # Update each actor
      @update_queue.each do |actor|
        actor.update
      end unless paused?
    end

    # Main draw loop
    def draw
      # to call draw on behaviors (that in turn will call
      # draw on systems, for example)
      super

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

  end
end
