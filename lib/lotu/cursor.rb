# Provides a mouse pointer usable through mouse or keyboard
module Lotu
  class Cursor < Actor
    attr_reader :click_x, :click_y
    attr_accessor :arrow_speed

    def initialize
      super
      @click_x = @click_y = 0
      @arrow_speed = 1
    end

    def update
      @x = $window.mouse_x
      @y = $window.mouse_y
    end

    # This is the method you want to call when a user press the
    # "click" key of your preference with something like:
    # set_keys Gosu::Button::MsLeft => :click
    # It'll yield the x, y coordinates of the click
    def click
      @click_x = $window.mouse_x
      @click_y = $window.mouse_y
      fire(:click, @click_x, @click_y)
    end

    def up
      $window.mouse_y -= @arrow_speed
    end

    def down
      $window.mouse_y += @arrow_speed
    end

    def left
      $window.mouse_x -= @arrow_speed
    end

    def right
      $window.mouse_x += @arrow_speed
    end

    def last_click
      "#{@click_x}, #{@click_y}"
    end
  end
end
