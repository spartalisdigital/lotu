module Lotu
  class Actor
    include Controllable
    attr_accessor :parent

    def initialize(parent)
      @parent = parent
      @parent.update_queue << self
      @parent.draw_queue << self
      @x = 0
      @y = 0
    end

    def update
    end

    def draw
    end
  end
end
