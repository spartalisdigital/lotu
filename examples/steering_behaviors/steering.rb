#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class SteeringRuby < Lotu::Actor
  def initialize
    super
    set_image 'CptnRuby Gem.png'
    activate_system Lotu::Steering
    @systems[Lotu::Steering].activate(:seek)
  end

  def warp(x, y)
    @pos.x, @pos.y = x, y
  end
end

class Example < Lotu::Window
  def initialize
    super
    set_keys KbEscape => :close

    with_path __FILE__ do
      load_images '../media'
    end

    @ruby = SteeringRuby.new
    @ruby.warp(width/2, height/2)
    @cursor = Lotu::Cursor.new(:image => 'crosshair.png',
                               :keys => {MsLeft => [:click, false]})
    @cursor.on(:click) do |x,y|
      @ruby.seek_target = Lotu::Vector2d.new(x,y)
    end

    @window_text_box = Lotu::TextBox.new
    @window_text_box.watch(@fps_counter)
    @window_text_box.watch(@cursor, :color => 0xffff0000)
    @ruby_text_box = Lotu::TextBox.new(:font_size => 30, :attach_to => @ruby)
    @ruby_text_box.watch(@ruby, :font_size => 18)
  end
end

Example.new.show
