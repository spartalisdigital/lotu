module Lotu
  class Window < Gosu::Window
    include Controllable
    include Resourceful
    attr_accessor :update_queue, :draw_queue, :input_listeners

    def initialize(params={})
      super(640, 480, false)

      # Handy global window variable
      $window = self

      # Systems setup
      @update_queue = []
      @draw_queue = []
      @input_register = Hash.new{|hash,key| hash[key] = []}

      @fps = FpsCounter.new
      @last_time = Gosu::milliseconds
    end

    def update
      new_time = Gosu::milliseconds
      elapsed_t = new_time - @last_time
      @last_time = new_time
      @fps.update(elapsed_t)

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
      @input_register[id].each do |item|
        item.button_down(id)
      end
    end

    def button_up(id)
      @input_register[id].each do |item|
        item.button_up(id)
      end
    end

    # Register controller
    def register_for_input(controller)
      controller.keys.each_key do |key|
        @input_register[key] << controller
      end
      @update_queue << controller
    end

    def register_for_draw(object)
      @draw_queue << object
    end
  end
end
