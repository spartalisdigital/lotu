module Lotu
  class Window < Gosu::Window
    # delta time
    attr_reader :dt, :systems
    attr_accessor :update_queue, :draw_queue, :input_listeners, :font

    def initialize(params={})
      super(640, 480, false)

      # Handy global window variable
      $window = self

      # Systems setup
      @systems = {}
      @update_queue = []
      @draw_queue = []
      @input_register = Hash.new{|hash,key| hash[key] = []}

      @fps_counter = FpsCounter.new
      @last_time = Gosu::milliseconds
      @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

      # Add extra functionality
      self.extend Controllable
      self.extend Resourceful
      extend Systems::Collision
    end

    def update
      new_time = Gosu::milliseconds
      @dt = (new_time - @last_time)/1000.0
      @last_time = new_time
      @fps_counter.update(@dt)

      @systems.each_value do |system|
        system.update
      end

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
