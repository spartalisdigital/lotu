module Lotu
  class Cursor < Actor
    def initialize(parent)
      super
      set_image('crosshair.png')
    end

    def update
      @x = $window.mouse_x
      @y = $window.mouse_y
    end
  end
end
