module Lotu
  class Actor
    extend Behavior

    behave_like SystemUser
    use AnimationSystem
    use InterpolationSystem

    behave_like Eventful
    behave_like Collidable
    behave_like Controllable

    attr_accessor :parent, :x, :y,
    :z, :angle, :center_x, :center_y,
    :factor_x, :factor_y, :color, :mode, :image,
    :width, :height

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
        :mode => :default,
        :parent => $lotu
      }

      opts = default_opts.merge!(opts)
      @parent = opts[:parent]
      @parent.manage_me(self)
      set_image(opts[:image], opts) if opts[:image]
      parse_options(opts)
      @color = rand_color if opts[:rand_color]
      set_keys(opts[:keys]) unless opts[:keys].nil?

      # so it can start behaving
      init_behavior opts
    end

    # Easy access to delta-time
    def dt
      $lotu.dt
    end

    def parse_options(opts)
      @x = opts[:x] || @x
      @y = opts[:y] || @y
      @z = opts[:z] || @z
      @angle = opts[:angle] || @angle
      @center_x = opts[:center_x] || @center_x
      @center_y = opts[:center_y] || @center_y
      @factor_x = opts[:factor_x] || @factor_x
      @factor_y = opts[:factor_y] || @factor_y
      @color = opts[:color] || @color
      if @color.kind_of?(Integer)
        @color = Gosu::Color.new(opts[:color])
      end
      @mode = opts[:mode] || @mode
    end

    def rand_color
      Gosu::Color.from_hsv(rand(360), 1, 1)
    end

    def set_image(image, opts={})
      @image = @parent.image(image)
      if @image.nil?
        puts "Image \"#{image}\" not found".red
        return
      end
      parse_options(opts)
      adjust_width_and_height(opts)
      calc_zoom
    end

    def set_gosu_image(image, opts={})
      @image = image
      parse_options(opts)
      adjust_width_and_height(opts)
      calc_zoom
    end

    def width=(width)
      @width = Float(width)
      calc_zoom
    end

    def height=(height)
      @height = Float(height)
      calc_zoom
    end

    def adjust_width_and_height(opts)
      if(opts[:width] && opts[:height])
        @width = Float(opts[:width])
        @height = Float(opts[:height])
      elsif(opts[:width])
        @width = Float(opts[:width])
        @height = @width * @image.height / @image.width
      elsif(opts[:height])
        @height = Float(opts[:height])
        @width = @height * @image.width / @image.height
      else
        @width = Float(@image.width)
        @height = Float(@image.height)
      end
    end

    def calc_zoom
      @zoom_x = Float(@width)/@image.width
      @zoom_y = Float(@height)/@image.height
    end

    # Remove ourselves from the update queue
    def die
      @parent.kill_me(self)
    end

    def update
      # to call update on behaviors (that in turn wil call
      # update on systems, for example)
      super
    end

    def draw
      # to call draw on behaviors (that in turn will call
      # draw on systems, for example)
      super

      unless @image.nil?
        @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @factor_x*@zoom_x, @factor_y*@zoom_y, @color, @mode)
        draw_debug if $lotu.debug?
      end
    end

    def draw_debug
      draw_box(@x-@image.width/2, @y-@image.height/2, @image.width, @image.height)
      draw_box(@x-@width/2, @y-@height/2, @width, @height, 0xff00ff00)
    end

    def draw_box(x, y, w, h, c = 0xffff0000)
      $lotu.draw_line(x, y, c, x+w, y, c)
      $lotu.draw_line(x, y, c, x, y+h, c)
      $lotu.draw_line(x+w, y+h, c, x+w, y, c)
      $lotu.draw_line(x+w, y+h, c, x, y+h, c)
    end

  end
end
