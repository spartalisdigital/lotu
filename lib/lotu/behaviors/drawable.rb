module Lotu
  module Drawable

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior
      @_image = nil
      @_color = 0xffffffff
    end

    def set_image(image)
      @_image = @parent.image(image)
      @parent.draw_queue << self unless @parent.draw_queue.include?(self)
    end

    def draw
      @_image.draw(@x,@y,0)
    end

    def die
      super
      @parent.draw_queue.delete(self)
    end

  end
end
