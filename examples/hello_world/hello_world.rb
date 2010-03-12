#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class Player < Lotu::Actor
  is_drawable
  is_controllable

  attr_reader :speed

  def initialize
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

  def warp(x, y)
    @x, @y = x, y
  end
end

class Example < Lotu::Window
  is_controllable
  is_resourceful

  def initialize
    super
    set_keys KbEscape => :close
    with_path(__FILE__) do
      load_images '../media'
      load_sounds '../media'
    end

    @player = Player.new
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def draw
    super
    @font.draw("FPS: #{@fps}", 10, 10, 0, 1.0, 1.0, 0xffffff00)
  end
end

Example.new.show
