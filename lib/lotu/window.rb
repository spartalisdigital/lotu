module Lotu
  class Window < Gosu::Window
    attr_accessor :update_queue, :draw_queue, :input_listeners

    def initialize(params={})
      $window = self
      super(640, 480, false)
      @update_queue = []
      @draw_queue = []
      @input_listeners = Hash.new{|hash,key| hash[key] = []}
      Actor.new(self)
      @controller = InputController.new(self, Gosu::Button::KbEscape => :quit)
    end

    def update
      @update_queue.each do |item|
        item.update
      end
    end

    def draw
      @draw_queue.each do |item|
        item.draw
      end
    end

    def button_down(id)
      @input_listeners[id].each do |listener|
        listener.button_down(id)
        puts listener
      end
    end

    def button_up(id)
      @input_listeners[id].each do |listener|
        listener.button_up(id)
      end
    end

    def add_input_listener(listener)
      listener.keys.each_key do |key|
        @input_listeners[key] << listener
      end
      @update_queue << listener
    end

    def quit
      self.close
    end
  end

end
