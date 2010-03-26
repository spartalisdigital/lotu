module Lotu
  class Actor
    attr_accessor :parent, :x, :y, :systems,
    :z, :angle, :center_x, :center_y,
    :factor_x, :factor_y, :color, :mode, :image

    include SystemUser

    def initialize(opts={})
      default_opts = {
        :x => 0,
        :y => 0,
        :z => 0,
        :angle => 0.0,
        :center_x => 0.5,
        :center_y => 0.5,
        :factor_x => 1.0,
        :factor_y => 1.0,
        :color => 0xffffffff,
        :mode => :default
      }
      @opts = default_opts.merge!(opts)
      @image = nil
      @x = @opts[:x]
      @y = @opts[:y]
      @z = @opts[:z]
      @angle = @opts[:angle]
      @center_x = @opts[:center_x]
      @center_y = @opts[:center_y]
      @factor_x = @opts[:factor_x]
      @factor_y = @opts[:factor_y]
      @color = @opts[:color]
      @mode = @opts[:mode]

      @parent = $window

      # Add extra functionality
      self.extend Controllable
      self.extend Eventful
      self.extend Collidable

      @systems = {}
      @parent.manage_me(self)
    end

    # Easy access to delta-time
    def dt
      $window.dt
    end

    def set_image(image)
      @image = @parent.image(image)
    end

    def unset_image
      @image = nil
    end

    # Remove ourselves from the update queue
    def die
      @parent.kill_me(self)
    end

    def update
      @systems.each_pair do |klass, system|
        system.update
      end
    end

    def draw
      @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode) unless @image.nil?
    end

  end
end
