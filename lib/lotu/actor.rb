module Lotu

  class Actor
    attr_accessor :parent

    def initialize(parent)
      @parent = parent
      @parent.update_queue << self
      @parent.draw_queue << self
      @x = 0
      @y = 0

      @controller = InputController.new(self, {Gosu::Button::KbRight => :puts_data})      
    end

    def update
    end

    def draw
    end

    def puts_data
      puts @parent.update_interval
      puts Gosu.milliseconds
    end
  end

end
