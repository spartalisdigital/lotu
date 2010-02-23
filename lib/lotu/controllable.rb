module Lotu
  module Controllable
    def has_keys(keys)
      @controller = InputController.new(self, keys)
    end
  end
end
