# Provides a mouse pointer usable through mouse or keyboard
module Lotu
  class Cursor < Actor
    attr_reader :clicked_x, :clicked_y
    attr_accessor :speed, :use_mouse

    def initialize
      super
      @clicked_x = @clicked_y = 0
      @speed = 100
      @use_mouse = true
    end

    def update
      if @use_mouse
        @x = $window.mouse_x
        @y = $window.mouse_y
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
      $window.mouse_y = @y
      $window.mouse_x = @x
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
  end
end
