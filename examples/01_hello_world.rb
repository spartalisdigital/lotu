LIB_PATH = File.join(File.dirname(__FILE__), '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class Player < Lotu::Actor
  def move_right
    @x += 1
  end

  def move_left
    @x -= 1
  end

  def move_up
    @y -= 1
  end

  def move_down
    @y += 1
  end
end

class Example < Lotu::Window
  def initialize
    super
    set_keys(KbEscape => :close)
    load_resources('media')
    
    @player = Player.new(self)
    @player.set_keys(KbRight => [:move_right, 0],
                     KbLeft => [:move_left, 0],
                     KbUp => [:move_up, 0],
                     KbDown => [:move_down, 0])
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @player.set_image('Soldier.png')
  end

  def draw
    super
    @font.draw("FPS: #{@fps}", 10, 10, 0, 1.0, 1.0, 0xffffff00)
  end
end
puts Lotu.game_path
Example.new.show
