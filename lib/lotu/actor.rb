module Lotu
  class Actor
    include Controllable
    include Drawable
    attr_accessor :parent, :x, :y

    def initialize(parent)
      @parent = parent
      @parent.update_queue << self
      @x = 0
      @y = 0
    end

    def update
    end
  end
end
