# Provides a mouse pointer usable through mouse or keyboard
module Lotu
  class Cursor < Actor
    use_systems :interpolation

    attr_reader :clicked_x, :clicked_y
    attr_accessor :speed, :use_mouse

    def initialize(opts={})
      default_opts = {
        :use_mouse => true,
        :speed => 300,
        :x => $lotu.width/2,
        :y => $lotu.height/2
      }
      opts = default_opts.merge!(opts)
      super
      $lotu.mouse_x = opts[:x]
      $lotu.mouse_y = opts[:y]
      @clicked_x = @clicked_y = 0
      @speed = opts[:speed]
      @use_mouse = opts[:use_mouse]
    end

    def update
      super
      if @use_mouse
        @x = $lotu.mouse_x
        @y = $lotu.mouse_y
      end
    end

    # This is the method you want to call when a user press the
    # "click" key of your preference with something like:
    # set_keys Gosu::Button::MsLeft => :click
    # It'll yield the x, y coordinates of the clicked point
    def click
      @clicked_x = @x
      @clicked_y = @y
      fire(:click, @clicked_x, @clicked_y)
    end

    def adjust_mouse
      $lotu.mouse_y = @y
      $lotu.mouse_x = @x
    end

    def up
      @y -= @speed * dt
      adjust_mouse if use_mouse
    end

    def down
      @y += @speed * dt
      adjust_mouse if use_mouse
    end

    def left
      @x -= @speed * dt
      adjust_mouse if use_mouse
    end

    def right
      @x += @speed * dt
      adjust_mouse if use_mouse
    end

    def to_s
      ["@pos(#{format('%.2f, %.2f', @x, @y)})",
       "@clicked(#{format('%.2f, %.2f', @clicked_x, @clicked_y)})"]
    end

  end
end
