module Lotu
  class Actor
    extend HasBehavior

    attr_accessor :parent, :x, :y

    def initialize(opts={})
      super()
      @x = opts[:x] || 0
      @y = opts[:y] || 0
      @parent = $window
      @parent.update_queue << self

      # Initialize the behaviors included in subclasses
      init_behavior
    end

    def dt
      $window.dt
    end

    def die
      @parent.update_queue.delete(self)
    end

    # Meant to be overriden by behaviors
    def init_behavior;end
    def update;end
  end
end
