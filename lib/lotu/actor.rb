module Lotu
  class Actor
    attr_accessor :parent, :x, :y, :systems,
    :z, :angle, :center_x, :center_y,
    :factor_x, :factor_y, :color, :mode, :image,
    :width, :height

    include SystemUser
    include Controllable

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
      @systems = {}

      # Add extra functionality
      self.extend Eventful
      self.extend Collidable
      use(AnimationSystem)
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
      @mode = opts[:mode] || @mode
    end

    def set_image(image, opts={})
      @image = @parent.image(image)
      puts "Image \"#{image}\" not found".red if @image.nil?
      parse_options(opts)
      @width = opts[:width] || @image.width
      @height = opts[:height] || @image.height
      calc_zoom
    end

    def set_gosu_image(image, opts={})
      @image = image
      parse_options(opts)
      @width = opts[:width] || @image.width
      @height = opts[:height] || @image.height
      calc_zoom
    end

    def width=(width)
      @width = width
      calc_zoom
    end

    def height=(height)
      @height = height
      calc_zoom
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
      @systems.each_pair do |klass, system|
        system.update
      end
    end

    def draw
      @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @factor_x*@zoom_x, @factor_y*@zoom_y, @color, @mode) unless @image.nil?
      draw_debug if $lotu.debug? unless @image.nil?
    end

    def draw_debug
      puts "w: #{@width} h: #{@height}".red if self.kind_of?(Missile)
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
