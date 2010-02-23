lib_path = File.join(File.dirname(__FILE__), '..', 'lib', 'lotu.rb')
require File.expand_path(lib_path)
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
    has_keys(KbEscape => :close)
    
    @player = Player.new(self)
    @player.has_keys(KbRight => [:puts_data, 50])
  end
end
Example.new.show
