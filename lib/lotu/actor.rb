module Lotu
  class Actor
    attr_accessor :parent, :x, :y

    def initialize(opts={})
      default_opts = {
        :x => 0,
        :y => 0,
        :color => 0xffffffff
      }
      opts = default_opts.merge!(opts)
      @x = opts[:x]
      @y = opts[:y]
      @color = opts[:color]
      @parent = $window
      @parent.update_queue << self

      # Add extra functionality
      self.extend Drawable
      self.extend Controllable
      self.extend Eventful
    end

    # Easy access to delta-time
    def dt
      $window.dt
    end

    # Remove ourselves from the update queue
    def die
      @parent.update_queue.delete(self)
    end

    def update;end
  end
end
