module Lotu
  module Drawable

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior
      @image = nil
      @color = 0xffffffff
      @z = 0
      @angle = 0
      @center_x = 0
      @center_y = 0
      @factor_x = 1
      @factor_y = 1
      @color = 0xffffffff
      @mode = :default
    end

    def set_image(image)
      @image = @parent.image(image)
      @parent.draw_queue << self unless @parent.draw_queue.include?(self)
    end

    def draw
      @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode)
    end

    def die
      super
      @parent.draw_queue.delete(self)
    end

  end
end
