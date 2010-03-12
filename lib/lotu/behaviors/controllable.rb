# Convenience module to set up an InputController
module Lotu
  module Controllable
    def is_controllable
      include InstanceMethods
    end

    module InstanceMethods
      def init_behavior
        super
        @_input_controller = nil
      end
      # This will call #go_up every game loop
      # Gosu::Button::KbUp => :go_up
      # This is the same as the above
      # Gosu::Button::KbUp => [:go_up, 0]
      #
      # This will call #go_up once
      # Gosu::Button::KbUp => [:go_up, false]
      #
      # This will call #go_up every 50ms
      # Gosu::Button::KbUp => [:go_up, 50]
      def set_keys(keys)
        @_input_controller = InputController.new(self, keys)
      end
    end
  end
end
