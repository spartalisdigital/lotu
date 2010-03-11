module Lotu
  class Actor
    include Controllable
    include Drawable
    attr_accessor :parent, :x, :y

    def initialize(parent)
      @x = 0
      @y = 0
      @parent = parent
      @parent.update_queue << self
    end

    def update
    end

    def dt
      $window.dt
    end
  end
end
