module Lotu
  class Window < Gosu::Window
    # Make it able to receive input events
    include Controllable
    # Make it able to load media resources
    include Resourceful

    # delta time
    attr_reader :dt
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
      puts "Window: #{__FILE__}"
    end

    def update
      new_time = Gosu::milliseconds
      @dt = (new_time - @last_time)/1000.0
      @last_time = new_time
      @fps.update(@dt)

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
