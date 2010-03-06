# Add method to create an input receiver
module Lotu
  module Controllable
    def set_keys(keys)
      @_input_controller = InputController.new(self, keys)
    end

    # Detach this controller from the input register
    def unset_keys
      
    end
  end
end
