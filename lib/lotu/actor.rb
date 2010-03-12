module Lotu
  class Actor
    include Controllable
    include Drawable
    include Eventful
    attr_accessor :parent, :x, :y

    def initialize
      super
      @x = 0
      @y = 0
      @parent = $window
      @parent.update_queue << self
    end

    def update
    end

    def dt
      $window.dt
    end
  end
end
