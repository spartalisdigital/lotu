#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class MovingRuby < Lotu::Actor

  def initialize(opts={})
    super
    set_image 'CptnRuby Gem.png'
    set_keys(KbRight => :move_right,
             KbLeft => :move_left,
             KbUp => :move_up,
             KbDown => :move_down)
  end

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

    with_path_from_file(__FILE__) do
      load_images '../media'
    end

    @ruby = MovingRuby.new(:x => width/2, :y => height/2)
    @info = Lotu::TextBox.new
    @info.text("Move around with arrow keys")
  end

end

Example.new.show
