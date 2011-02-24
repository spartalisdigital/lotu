module Lotu
  class Game < Gosu::Window
    extend Behavior

    behave_like SystemUser
    use InputManagerSystem

    behave_like ResourceManager

    # Accessors for elapsed time since last update (time delta) and fonts
    attr_reader :dt
    # Accessors for queues
    attr_accessor :update_queue, :draw_queue, :input_listeners

    def initialize(opts={})
      default_opts = {
        :width => 1024,
        :height => 768,
        :fullscreen => false
      }
      opts = default_opts.merge!(opts)
      super(opts[:width], opts[:height], opts[:fullscreen])

      # Handy global window variable
      $lotu = self
      @debug = opts[:debug] || false
      @pause = false
      setup_containers

      # For timer initialization
      @last_time = Gosu::milliseconds

      # so it can start behaving
      init_behavior opts

      # Call hook methods
      load_resources
      setup_actors
      setup_input
      setup_events
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

      # Update each actor
      @update_queue.each do |actor|
        actor.update
      end unless paused?

      # to call update on behaviors (that in turn wil call
      # update on systems, for example)
      super
    end

    # Main draw loop
    def draw
      # Draw each actor in queue
      @draw_queue.each do |actor|
        actor.draw
      end

      # to call draw on behaviors (that in turn will call
      # draw on systems, for example)
      super
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
