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
      @once_actions = []

      # Last time an action was executed (so we can implement some
      # rate of fire)
      @executed_at = {}

      # Register this controller with the main window
      $window.register_for_input(self)
    end

    # If there are some actions currently going on, dispatch them
    def update
      @once_actions.each do |action_name, rate|
        @subject.send(action_name)
      end.clear

      @actions.each do |action_name, rate|
        # action usually is a [:action_name, rate_of_fire] pair, for
        # example: [:fire, 50] will call #fire every 50ms
        time_now = Gosu.milliseconds
        if @executed_at[action_name] + (rate || 0) < time_now
          @executed_at[action_name] = time_now
          @subject.send(action_name)
        end
      end
    end

    def button_down(id)
      action_name, rate = @keys[id]
      @executed_at[action_name] ||= 0
      if rate == false
        @once_actions << @keys[id]
      else
        @actions << @keys[id]
      end
    end

    def button_up(id)
      @actions.delete(@keys[id])
    end

  end
end
