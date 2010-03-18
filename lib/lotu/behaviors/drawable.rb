module Lotu
  module Drawable

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior
      @_image = nil
      @_color = 0xffffffff
      @_z = 0
      @_angle = 0
      @_center_x = 0
      @_center_y = 0
      @_factor_x = 1
      @_factor_y = 1
      @_color = 0xffffffff
      @_mode = :default
    end

    def set_image(image)
      @_image = @parent.image(image)
      @parent.draw_queue << self unless @parent.draw_queue.include?(self)
    end

    def draw
      @_image.draw_rot(@x, @y, @_z, @_angle, @_center_x, @_center_y, @_factor_x, @_factor_y, @_color, @_mode)
    end

    def die
      super
      @parent.draw_queue.delete(self)
    end

  end
end
