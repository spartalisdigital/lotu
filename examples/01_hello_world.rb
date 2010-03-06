LIB_PATH = File.join(File.dirname(__FILE__), '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class Player < Lotu::Actor
  def puts_data
    puts @parent.update_interval
    puts Gosu.milliseconds
  end
end

class Example < Lotu::Window
  def initialize
    super
    set_keys(KbEscape => :close)
    load_resources('media')
    
    @player = Player.new(self)
    @player.set_keys(KbRight => [:puts_data, 50])
    @player.set_image('Soldier.png')
  end
end

Example.new.show
