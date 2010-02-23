module Lotu
  class InputController
    attr_accessor :subject, :keys

    def initialize(subject, keys)
      # The subject being controlled
      @subject = subject

      # Key mappings {Gosu::Button::KbEscape => :quit, ...}
      @keys = keys

      # Current ongoing actions (button is being pushed)
      @actions = []

      # Last time an action was executed (so we can implement some
      # rate of fire)
      @executed_at = {}

      # Register this controller with the main window
      $window.register_input_controller(self)
    end

    # If there are some actions currently going on, dispatch them
    def update
      @actions.each do |action|
        # action usually is a [:action_name, rate_of_fire] pair, for
        # example: [:fire, 50] will call #fire every 50ms
        action_name, rate = action
        time_now = Gosu.milliseconds
        if @executed_at[action] + (rate || 1000) < time_now
          @executed_at[action] = time_now
          @subject.send(action_name)
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
