#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class SteeringRuby < Lotu::Actor
  def initialize(opts={})
    super
    set_image 'CptnRuby Gem.png'
    activate_system(Lotu::Steering, opts)
  end

  def warp(x, y)
    @pos.x, @pos.y = x, y
  end
end

class Example < Lotu::Window
  def initialize
    super
    set_keys(KbEscape => :close,
             MsRight => :reset_ruby)

    with_path_from_file(__FILE__) do
      load_images '../media'
    end

    @ruby = SteeringRuby.new(:mass => 0.3, :max_speed => 100, :max_turn_rate => 140)
    @ruby.warp(width/2, height/2)
    @ruby.activate(:evade)

    @ruby2 = SteeringRuby.new
    @ruby2.activate(:pursuit)

    @cursor = Lotu::Cursor.new(:image => 'crosshair.png',
                               :keys => {MsLeft => [:click, false]})
    @cursor.on(:click) do |x,y|
      @ruby.pursuer = @ruby2
      @ruby2.evader = @ruby
    end

    @window_info = Lotu::TextBox.new
    @window_info.watch(@fps_counter)
    @window_info.watch(@cursor, :color => 0xffff0000)

    @ruby_info = Lotu::TextBox.new(:attach_to => @ruby, :font_size => 16)
    @ruby_info.watch(@ruby)
  end

  def reset_ruby
    @ruby.pos.x = width/2
    @ruby.pos.y = height/2
  end
end

Example.new.show
