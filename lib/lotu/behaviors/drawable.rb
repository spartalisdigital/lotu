module Lotu
  module Drawable
    def set_image(image)
      @_image = $window.resource(image)
      $window.register_for_draw(self)
    end

    def unset_image
    end

    def draw
      @_image.draw(@x,@y,0)
    end
  end
end
