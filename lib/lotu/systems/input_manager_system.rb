module Lotu
  class InputManagerSystem < BaseSystem

    def initialize(user, opts={})
      super
      @user.extend UserMethods
      # Current ongoing actions (button is being pushed)
      @actions = []
      @unique_actions = []

      # Last time an action was executed (so we can implement some
      # rate of fire)
      @last_time_fired = Hash.new{|h,k| h[k] = Hash.new{|h,k| h[k] = 0}}

      # Think of it like a reverse proxy
      @reverse_register = Hash.new{|h,k| h[k] = []}
    end

    # If there are some actions currently going on, dispatch them
    def update
      @unique_actions.each do |client, action_name, rate|
        client.send(action_name)
      end.clear

      @actions.each do |client, action_name, rate|
        # action usually is a [:action_name, rate_of_fire] pair, for
        # example: [:fire, 50] will call #fire every 50ms
        time_now = Gosu.milliseconds
        if @last_time_fired[client][action_name] + (rate || 0) < time_now
          client.send(action_name)
          @last_time_fired[client][action_name] = time_now
        end
      end
    end

    def set_keys(client, keys)
      keys.each do |key, action|
        @reverse_register[key] << [client, action]
      end
    end

    def button_down(key)
      @reverse_register[key].each do |client, action|
        action_name, rate = action
        if rate == false
          @unique_actions << [client, action_name, rate]
        else
          @actions << [client, action_name, rate]
        end
      end
    end

    def button_up(key)
      @reverse_register[key].each do |client, action|
        action_name, rate = action
        @actions.delete [client, action_name, rate]
      end
    end

    module UserMethods
      def set_keys(keys)
        systems[InputManagerSystem].set_keys(self, keys)
      end

      def button_down(key)
        systems[InputManagerSystem].button_down(key)
      end

      def button_up(key)
        systems[InputManagerSystem].button_up(key)
      end
    end

  end
end
