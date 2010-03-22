module Lotu
  module Drawable

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior
      class << self
        attr_accessor :z, :angle, :center_x, :center_y,
        :factor_x, :factor_y, :color, :mode
      end

      default_opts = {
        :z => 0,
        :angle => 0.0,
        :center_x => 0.5,
        :center_y => 0.5,
        :factor_x => 1.0,
        :factor_y => 1.0,
        :color => 0xffffffff,
        :mode => :default
      }
      @opts = default_opts.merge!(@opts)

      @image = nil
      @z = @opts[:z]
      @angle = @opts[:angle]
      @center_x = @opts[:center_x]
      @center_y = @opts[:center_y]
      @factor_x = @opts[:factor_x]
      @factor_y = @opts[:factor_y]
      @color = @opts[:color]
      @mode = @opts[:mode]
    end

    def draw_me
      @parent.draw_queue << self unless @parent.draw_queue.include?(self)
    end

    def image
      @image
    end

    def set_image(image)
      @image = @parent.image(image)
      draw_me
    end

    def draw
      super
      @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode) unless @image.nil?
    end

    def die
      super
      @parent.draw_queue.delete(self)
    end

  end
end
