module Lotu

  class InputController
    attr_accessor :controlled, :keys

    def initialize(controlled, keys)
      @controlled = controlled
      @keys = keys
      @actions = []
      @executed_at = {}
      $window.add_input_listener(self)
    end

    def update
      @actions.each do |action|
        time_now = Gosu.milliseconds
        if @executed_at[action] + 1000 < time_now
          @executed_at[action] = time_now
          @controlled.send(action)
        end
      end
    end

    def button_down(id)
      @executed_at[@keys[id]] ||= 0
      @actions << @keys[id]
    end

    def button_up(id)
      @actions.delete(@keys[id])
    end
  end

end
