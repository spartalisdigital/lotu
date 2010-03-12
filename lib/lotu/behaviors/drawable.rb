module Lotu
  module Drawable
    def is_drawable
      include InstanceMethods
    end

    module InstanceMethods
      def init_behavior
        super
        @_image = nil
      end

      def set_image(image)
        @_image = $window.image(image)
        $window.register_for_draw(self)
      end

      def draw
        @_image.draw(@x,@y,0)
      end
    end
  end
end
