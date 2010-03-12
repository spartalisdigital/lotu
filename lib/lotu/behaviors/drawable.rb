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
        @parent.register_for_draw(self)
      end

      def draw
        @_image.draw(@x,@y,0)
      end

      def die
        super
        @parent.draw_queue.delete(self)
      end
    end
  end
end
